-- plugin/go.lua
-- Plugin bootstrap for go.nvim

-- Auto-load for Go files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = { "*.go" },
    callback = function()
        -- Check if we should load the plugin
        if require("go").should_load() then
            -- Plugin is already loaded via lazy.nvim
        end
    end,
})

-- User commands
vim.api.nvim_create_user_command("GoSetup", function()
    require("go").setup()
end, { desc = "Setup Go environment for current project" })

vim.api.nvim_create_user_command("GoModule", function()
    require("go").show_module_picker()
end, { desc = "Show module picker" })

vim.api.nvim_create_user_command("GoInstall", function(opts)
    local package_name = opts.fargs[1]
    if not package_name then
        vim.notify("Please specify a package name (e.g., :GoInstall github.com/example/package)", vim.log.levels.WARN, { title = "go.nvim" })
        return
    end
    require("go").install_package(package_name)
end, { desc = "Install Go package", nargs = 1 })

vim.api.nvim_create_user_command("GoFormat", function()
    require("go").format_buffer()
end, { desc = "Format current Go buffer" })

vim.api.nvim_create_user_command("GoLint", function()
    require("go").lint_buffer()
end, { desc = "Lint current Go buffer" })

vim.api.nvim_create_user_command("GoLintWith", function(opts)
    local linter = opts.fargs[1]
    if not linter then
        vim.notify("Please specify a linter (e.g., :GoLintWith golint)", vim.log.levels.WARN, { title = "go.nvim" })
        return
    end
    require("go").lint_with(linter)
end, { desc = "Lint current Go buffer with specific linter", nargs = 1, complete = function()
    return { "golint", "staticcheck", "revive" }
end })

vim.api.nvim_create_user_command("GoTest", function()
    require("go").run_tests()
end, { desc = "Run Go tests" })

vim.api.nvim_create_user_command("GoDebug", function()
    require("go").start_debugging()
end, { desc = "Start debugging session" })

vim.api.nvim_create_user_command("GoREPL", function()
    require("go").open_repl()
end, { desc = "Open Go REPL" })

-- Task runner commands
vim.api.nvim_create_user_command("GoTask", function()
    require("go").show_task_picker()
end, { desc = "Show task picker" })

vim.api.nvim_create_user_command("GoTaskHistory", function()
    require("go").show_task_history_picker()
end, { desc = "Show task history" })

vim.api.nvim_create_user_command("GoTaskRerun", function()
    require("go").rerun_last_task()
end, { desc = "Re-run last task" })

vim.api.nvim_create_user_command("GoTaskClearHistory", function()
    require("go").clear_task_history()
end, { desc = "Clear task history" })

-- Package management commands
vim.api.nvim_create_user_command("GoPackage", function()
    require("go").show_package_picker()
end, { desc = "Show package picker" })

-- Import management commands
vim.api.nvim_create_user_command("GoImport", function()
    require("go").organize_imports()
end, { desc = "Organize imports" })

vim.api.nvim_create_user_command("GoImportPicker", function()
    require("go").show_import_picker()
end, { desc = "Show import picker" })

-- Coverage commands
vim.api.nvim_create_user_command("GoCoverage", function()
    require("go").run_coverage()
end, { desc = "Run test coverage" })

vim.api.nvim_create_user_command("GoCoverageReport", function()
    require("go").show_coverage_report()
end, { desc = "Show coverage report" })

-- Debug commands
vim.api.nvim_create_user_command("GoDebugToggle", function()
    require("go").toggle_debug()
end, { desc = "Toggle debug mode" })

-- Keymaps
if vim.g.mapleader then
    local keymap_opts = { noremap = true, silent = true }
    
    -- Core Go commands
    vim.keymap.set("n", "<leader>gm", "<cmd>GoModule<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gi", "<cmd>GoInstall<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gu", "<cmd>GoUpdate<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gf", "<cmd>GoFormat<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gl", "<cmd>GoLint<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gd", "<cmd>GoDebug<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gr", "<cmd>GoREPL<cr>", keymap_opts)
    
    -- Task runner commands
    vim.keymap.set("n", "<leader>gt", "<cmd>GoTask<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gh", "<cmd>GoTaskHistory<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gr", "<cmd>GoTaskRerun<cr>", keymap_opts)
    
    -- Package management
    vim.keymap.set("n", "<leader>gp", "<cmd>GoPackage<cr>", keymap_opts)
    
    -- Import management
    vim.keymap.set("n", "<leader>gi", "<cmd>GoImport<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gip", "<cmd>GoImportPicker<cr>", keymap_opts)
    
    -- Coverage
    vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>gcr", "<cmd>GoCoverageReport<cr>", keymap_opts)
    
    -- Debug
    vim.keymap.set("n", "<leader>gdt", "<cmd>GoDebugToggle<cr>", keymap_opts)
end

-- Setup task runner keymaps
require("go").setup_task_keymaps() 