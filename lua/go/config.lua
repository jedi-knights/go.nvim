-- lua/go/config.lua
-- Configuration management for go.nvim

local M = {}

-- Default configuration
local default_config = {
    go_command = "go",
    enable_module_support = true,
    auto_detect_modules = true,
    
    -- Formatters
    formatters = {
        gofmt = { enabled = true },
        goimports = { enabled = true },
        golines = { enabled = false },
    },
    
    -- Linters
    linters = {
        golint = { enabled = true },
        staticcheck = { enabled = true },
        revive = { enabled = false },
    },
    
    -- Test frameworks
    test_frameworks = {
        go_test = { enabled = true },
        testify = { enabled = true },
        ginkgo = { enabled = false },
    },
    
    -- Task runners
    task_runner = {
        enabled = true,
        go_task = { enabled = true },
        make = { enabled = true },
        scripts = { enabled = true },
    },
    
    -- Module management
    modules = {
        default = "go.mod",
        auto_create = true,
        auto_detect = true,
        mod_path = "go.mod",
    },
    
    -- Package management
    package_manager = "go",
    auto_install_deps = true,
    
    -- Code intelligence
    enable_import_sorting = true,
    enable_auto_import = true,
    enable_type_checking = true,
    
    -- Test coverage
    test_coverage = {
        enabled = true,
        tool = "go",
        show_inline = true,
    },
    
    -- Debugging
    debugger = {
        enabled = true,
        adapter = "delve",
        port = 2345,
    },
    
    -- REPL
    repl = {
        enabled = true,
        floating = true,
        auto_import = true,
    },
    
    -- UI
    enable_floating_terminals = true,
    enable_notifications = true,
    enable_debugging = true,
    
    -- Logging
    log_level = vim.log.levels.INFO,
    debug = false,
}

-- Module state
local config = {}

---Validate configuration
---@param cfg go.Config Configuration to validate
---@return boolean valid
---@return string? error_message
local function validate_config(cfg)
    if type(cfg.go_command) ~= "string" or cfg.go_command == "" then
        return false, "go_command must be a non-empty string"
    end
    
    if type(cfg.enable_module_support) ~= "boolean" then
        return false, "enable_module_support must be a boolean"
    end
    
    if type(cfg.auto_detect_modules) ~= "boolean" then
        return false, "auto_detect_modules must be a boolean"
    end
    
    if type(cfg.formatters) ~= "table" then
        return false, "formatters must be a table"
    end
    
    if type(cfg.linters) ~= "table" then
        return false, "linters must be a table"
    end
    
    if type(cfg.test_frameworks) ~= "table" then
        return false, "test_frameworks must be a table"
    end
    
    if type(cfg.task_runner) ~= "table" then
        return false, "task_runner must be a table"
    end
    
    if type(cfg.modules) ~= "table" then
        return false, "modules must be a table"
    end
    
    if type(cfg.package_manager) ~= "string" then
        return false, "package_manager must be a string"
    end
    
    if type(cfg.auto_install_deps) ~= "boolean" then
        return false, "auto_install_deps must be a boolean"
    end
    
    if type(cfg.enable_import_sorting) ~= "boolean" then
        return false, "enable_import_sorting must be a boolean"
    end
    
    if type(cfg.enable_auto_import) ~= "boolean" then
        return false, "enable_auto_import must be a boolean"
    end
    
    if type(cfg.enable_type_checking) ~= "boolean" then
        return false, "enable_type_checking must be a boolean"
    end
    
    if type(cfg.test_coverage) ~= "table" then
        return false, "test_coverage must be a table"
    end
    
    if type(cfg.debugger) ~= "table" then
        return false, "debugger must be a table"
    end
    
    if type(cfg.repl) ~= "table" then
        return false, "repl must be a table"
    end
    
    if type(cfg.enable_floating_terminals) ~= "boolean" then
        return false, "enable_floating_terminals must be a boolean"
    end
    
    if type(cfg.enable_notifications) ~= "boolean" then
        return false, "enable_notifications must be a boolean"
    end
    
    if type(cfg.enable_debugging) ~= "boolean" then
        return false, "enable_debugging must be a boolean"
    end
    
    if type(cfg.log_level) ~= "number" then
        return false, "log_level must be a number"
    end
    
    if type(cfg.debug) ~= "boolean" then
        return false, "debug must be a boolean"
    end
    
    return true
end

---Setup the plugin configuration
---@param opts? go.Config Configuration options
---@param deps? table Dependencies for testing
---@return boolean success
function M.setup(opts, deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    local tbl_extend = deps.tbl_deep_extend or vim.tbl_deep_extend
    
    local new_config = tbl_extend("force", default_config, opts or {})
    
    local ok, err = pcall(validate_config, new_config)
    if not ok then
        notify("Invalid go.nvim configuration: " .. tostring(err), vim.log.levels.ERROR, { title = "go.nvim" })
        return false
    end
    
    -- Update module state
    for k, v in pairs(new_config) do
        config[k] = v
    end
    
    return true
end

---Get current configuration
---@param deps? table Dependencies for testing
---@return go.Config config
function M.get(deps)
    return config
end

---Get formatter settings
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return go.FormatterSettings? settings
function M.get_formatter_settings(formatter_name, deps)
    deps = deps or {}
    
    if not config.formatters then
        return nil
    end
    
    return config.formatters[formatter_name]
end

---Get linter settings
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return go.LinterSettings? settings
function M.get_linter_settings(linter_name, deps)
    deps = deps or {}
    
    if not config.linters then
        return nil
    end
    
    return config.linters[linter_name]
end

---Get test framework settings
---@param framework_name string Name of the test framework
---@param deps? table Dependencies for testing
---@return go.TestFrameworkSettings? settings
function M.get_test_framework_settings(framework_name, deps)
    deps = deps or {}
    
    if not config.test_frameworks then
        return nil
    end
    
    return config.test_frameworks[framework_name]
end

---Get task runner settings
---@param runner_name string Name of the task runner
---@param deps? table Dependencies for testing
---@return go.TaskRunnerSettings? settings
function M.get_task_runner_settings(runner_name, deps)
    deps = deps or {}
    
    if not config.task_runner then
        return nil
    end
    
    return config.task_runner[runner_name]
end

---Check if a formatter is enabled
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_formatter_enabled(formatter_name, deps)
    deps = deps or {}
    local settings = M.get_formatter_settings(formatter_name, deps)
    return settings and settings.enabled or false
end

---Check if a linter is enabled
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_linter_enabled(linter_name, deps)
    deps = deps or {}
    local settings = M.get_linter_settings(linter_name, deps)
    return settings and settings.enabled or false
end

---Check if a test framework is enabled
---@param framework_name string Name of the test framework
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_test_framework_enabled(framework_name, deps)
    deps = deps or {}
    local settings = M.get_test_framework_settings(framework_name, deps)
    return settings and settings.enabled or false
end

---Check if a task runner is enabled
---@param runner_name string Name of the task runner
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_task_runner_enabled(runner_name, deps)
    deps = deps or {}
    local settings = M.get_task_runner_settings(runner_name, deps)
    return settings and settings.enabled or false
end

---Toggle debug mode
---@param deps? table Dependencies for testing
function M.toggle_debug(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    config.debug = not config.debug
    notify("go.nvim debug: " .. (config.debug and "enabled" or "disabled"), config.log_level, { title = "go.nvim" })
end

---Get debug mode status
---@param deps? table Dependencies for testing
---@return boolean debug_enabled
function M.get_debug_status(deps)
    return config.debug or false
end

---Get log level
---@param deps? table Dependencies for testing
---@return number log_level
function M.get_log_level(deps)
    return config.log_level or vim.log.levels.INFO
end

---Reset configuration to defaults
---@param deps? table Dependencies for testing
function M.reset(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    for k, v in pairs(default_config) do
        config[k] = v
    end
    
    if deps.debug then
        notify("Configuration reset to defaults", vim.log.levels.INFO, { title = "go.nvim" })
    end
end

---Create a new config instance (useful for testing)
---@param opts? go.Config Configuration options
---@param deps? table Dependencies for testing
---@return go.Config config
function M.new(opts, deps)
    deps = deps or {}
    local tbl_extend = deps.tbl_deep_extend or vim.tbl_deep_extend
    
    local new_config = tbl_extend("force", default_config, opts or {})
    local ok, err = pcall(validate_config, new_config)
    if not ok then
        error("Invalid configuration: " .. tostring(err))
    end
    
    return new_config
end

return M 