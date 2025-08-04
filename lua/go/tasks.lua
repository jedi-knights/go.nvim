-- lua/go/tasks.lua
-- Task runner integration for go.nvim

local M = {}

-- State for last task command and task history
local last_task_cmd = nil
local task_history = {}
local max_history = 10

---Run go-task task
---@param task_name string Name of the task to run
---@param args? table Arguments for the task
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_go_task(task_name, args, deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    local utils = deps.utils or require("go.utils")
    local notify = deps.notify or vim.notify
    
    -- Check if go-task is available
    if not detector.is_tool_available("task", deps) then
        notify("go-task is not available", vim.log.levels.ERROR, { title = "go.nvim" })
        return false
    end
    
    -- Check if Taskfile.yml exists
    if not utils.file_exists("Taskfile.yml") then
        notify("No Taskfile.yml found", vim.log.levels.WARN, { title = "go.nvim" })
        return false
    end
    
    local cmd = { "task", task_name }
    
    -- Add arguments
    if args then
        for key, value in pairs(args) do
            if type(value) == "boolean" then
                if value then
                    table.insert(cmd, "--" .. key)
                end
            else
                table.insert(cmd, "--" .. key)
                table.insert(cmd, tostring(value))
            end
        end
    end
    
    return M.run_task_command(cmd, "go_task", task_name, deps)
end

---Run make target
---@param target string Target to run
---@param args? table Arguments for the target
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_make_target(target, args, deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    local utils = deps.utils or require("go.utils")
    local notify = deps.notify or vim.notify
    
    -- Check if make is available
    if not detector.is_tool_available("make", deps) then
        notify("make is not available", vim.log.levels.ERROR, { title = "go.nvim" })
        return false
    end
    
    -- Check if Makefile exists
    if not utils.file_exists("Makefile") then
        notify("No Makefile found", vim.log.levels.WARN, { title = "go.nvim" })
        return false
    end
    
    local cmd = { "make", target }
    
    -- Add arguments
    if args then
        for key, value in pairs(args) do
            table.insert(cmd, key .. "=" .. tostring(value))
        end
    end
    
    return M.run_task_command(cmd, "make", target, deps)
end

---Run custom script
---@param script_path string Path to the script
---@param args? table Arguments for the script
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_custom_script(script_path, args, deps)
    deps = deps or {}
    local utils = deps.utils or require("go.utils")
    local notify = deps.notify or vim.notify
    
    -- Check if script exists
    if not utils.file_exists(script_path) then
        notify("Script not found: " .. script_path, vim.log.levels.ERROR, { title = "go.nvim" })
        return false
    end
    
    local cmd = { script_path }
    
    -- Add arguments
    if args then
        for _, arg in ipairs(args) do
            table.insert(cmd, arg)
        end
    end
    
    return M.run_task_command(cmd, "script", script_path, deps)
end

---Run task command with enhanced output handling
---@param cmd string[] Command to run
---@param runner_type string Type of runner (go_task, make, script)
---@param task_name string Name of the task
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_task_command(cmd, runner_type, task_name, deps)
    deps = deps or {}
    local utils = deps.utils or require("go.utils")
    local notify = deps.notify or vim.notify
    
    -- Store last command for re-running
    last_task_cmd = { cmd = cmd, runner_type = runner_type, task_name = task_name }
    
    -- Add to history
    table.insert(task_history, 1, {
        cmd = cmd,
        runner_type = runner_type,
        task_name = task_name,
        timestamp = os.time()
    })
    
    -- Keep history size manageable
    if #task_history > max_history then
        table.remove(task_history, #task_history)
    end
    
    local output_lines = {}
    local job_id = vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                if line and line ~= "" then
                    table.insert(output_lines, line)
                end
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                if line and line ~= "" then
                    table.insert(output_lines, line)
                end
            end
        end,
        on_exit = function(_, exit_code)
            local result = table.concat(output_lines, "\n")
            
            vim.schedule(function()
                if exit_code == 0 then
                    notify("✅ Task completed: " .. task_name .. "\n" .. result, vim.log.levels.INFO, { title = "go.nvim" })
                else
                    notify("❌ Task failed: " .. task_name .. "\n" .. result, vim.log.levels.ERROR, { title = "go.nvim" })
                end
            end)
        end,
    })
    
    if not job_id or job_id <= 0 then
        notify("Failed to start task: " .. task_name, vim.log.levels.ERROR, { title = "go.nvim" })
        return false
    end
    
    notify("Started task: " .. task_name, vim.log.levels.INFO, { title = "go.nvim" })
    return true
end

---Re-run last task
---@param deps? table Dependencies for testing
---@return boolean success
function M.rerun_last_task(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    if not last_task_cmd then
        notify("No previous task to re-run", vim.log.levels.WARN, { title = "go.nvim" })
        return false
    end
    
    return M.run_task_command(last_task_cmd.cmd, last_task_cmd.runner_type, last_task_cmd.task_name, deps)
end

---Discover go-task tasks
---@param deps? table Dependencies for testing
---@return table[] tasks
function M.discover_go_tasks(deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    local utils = deps.utils or require("go.utils")
    
    if not detector.is_tool_available("task", deps) then
        return {}
    end
    
    if not utils.file_exists("Taskfile.yml") then
        return {}
    end
    
    local output = utils.run_command({ "task", "--list" })
    if not output then
        return {}
    end
    
    local tasks = {}
    for line in output:gmatch("[^\r\n]+") do
        -- Skip header lines
        if line:match("^Available") then
            goto continue
        end
        
        -- Parse task line: task_name  Description
        local name, desc = line:match("^(%S+)%s+(.+)$")
        
        -- Insert parsed task into results
        if name and name ~= "" then
            table.insert(tasks, {
                name = name,
                desc = desc or "",
                runner_type = "go_task"
            })
        end
        
        ::continue::
    end
    
    return tasks
end

---Discover make targets
---@param deps? table Dependencies for testing
---@return table[] tasks
function M.discover_make_targets(deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    local utils = deps.utils or require("go.utils")
    
    if not detector.is_tool_available("make", deps) then
        return {}
    end
    
    if not utils.file_exists("Makefile") then
        return {}
    end
    
    local output = utils.run_command({ "make", "-qp", "R" })
    if not output then
        return {}
    end
    
    local tasks = {}
    for line in output:gmatch("[^\r\n]+") do
        -- Look for target definitions
        local target = line:match("^([%w_-]+):")
        if target and not target:match("^%.") then -- Skip special targets
            table.insert(tasks, {
                name = target,
                desc = "Make target",
                runner_type = "make"
            })
        end
    end
    
    return tasks
end

---Discover custom scripts
---@param deps? table Dependencies for testing
---@return table[] tasks
function M.discover_custom_scripts(deps)
    deps = deps or {}
    local utils = deps.utils or require("go.utils")
    
    local scripts = {}
    local script_patterns = {
        "*.sh",
        "*.go",
        "*.js",
        "*.rb",
        "*.pl"
    }
    
    for _, pattern in ipairs(script_patterns) do
        local files = utils.find_files(pattern)
        for _, file in ipairs(files) do
            -- Check if file is executable or has shebang
            local content = utils.read_file(file)
            if content and (content:match("^#!") or utils.is_executable(file)) then
                table.insert(scripts, {
                    name = file,
                    desc = "Custom script",
                    runner_type = "script"
                })
            end
        end
    end
    
    return scripts
end

---Discover all available tasks
---@param deps? table Dependencies for testing
---@return table[] tasks
function M.discover_all_tasks(deps)
    deps = deps or {}
    local tasks = {}
    
    -- Discover go-task tasks
    local go_tasks = M.discover_go_tasks(deps)
    for _, task in ipairs(go_tasks) do
        table.insert(tasks, task)
    end
    
    -- Discover make targets
    local make_targets = M.discover_make_targets(deps)
    for _, task in ipairs(make_targets) do
        table.insert(tasks, task)
    end
    
    -- Discover custom scripts
    local custom_scripts = M.discover_custom_scripts(deps)
    for _, task in ipairs(custom_scripts) do
        table.insert(tasks, task)
    end
    
    return tasks
end

---Show task picker
---@param deps? table Dependencies for testing
function M.show_task_picker(deps)
    deps = deps or {}
    local snacks = deps.snacks or require("snacks")
    local notify = deps.notify or vim.notify
    
    local tasks = M.discover_all_tasks(deps)
    if #tasks == 0 then
        notify("No tasks found", vim.log.levels.WARN, { title = "go.nvim" })
        return
    end
    
    local entries = {}
    for _, task in ipairs(tasks) do
        table.insert(entries, {
            text = task.name .. " (" .. task.runner_type .. ")",
            desc = task.desc,
            value = task
        })
    end
    
    snacks.select({
        prompt = "Select Task",
        items = entries,
        on_select = function(item)
            local task = item.value
            if task.runner_type == "go_task" then
                M.run_go_task(task.name, nil, deps)
            elseif task.runner_type == "make" then
                M.run_make_target(task.name, nil, deps)
            elseif task.runner_type == "script" then
                M.run_custom_script(task.name, nil, deps)
            end
        end
    })
end

---Show task history picker
---@param deps? table Dependencies for testing
function M.show_history_picker(deps)
    deps = deps or {}
    local snacks = deps.snacks or require("snacks")
    local notify = deps.notify or vim.notify
    
    if #task_history == 0 then
        notify("No task history", vim.log.levels.WARN, { title = "go.nvim" })
        return
    end
    
    local entries = {}
    for i, task in ipairs(task_history) do
        local time_str = os.date("%H:%M:%S", task.timestamp)
        table.insert(entries, {
            text = task.task_name .. " (" .. task.runner_type .. ") - " .. time_str,
            value = task
        })
    end
    
    snacks.select({
        prompt = "Task History",
        items = entries,
        on_select = function(item)
            local task = item.value
            M.run_task_command(task.cmd, task.runner_type, task.task_name, deps)
        end
    })
end

---Clear task history
---@param deps? table Dependencies for testing
function M.clear_task_history(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    task_history = {}
    notify("Task history cleared", vim.log.levels.INFO, { title = "go.nvim" })
end

---Get task history
---@param deps? table Dependencies for testing
---@return table[] history
function M.get_task_history(deps)
    return task_history
end

---Setup task runner keymaps
---@param deps? table Dependencies for testing
function M.setup_task_keymaps(deps)
    deps = deps or {}
    local keymap_opts = { noremap = true, silent = true }
    
    -- Task runner commands
    vim.keymap.set("n", "<leader>gt", function()
        M.show_task_picker(deps)
    end, keymap_opts)
    
    vim.keymap.set("n", "<leader>gh", function()
        M.show_history_picker(deps)
    end, keymap_opts)
    
    vim.keymap.set("n", "<leader>gr", function()
        M.rerun_last_task(deps)
    end, keymap_opts)
end

return M 