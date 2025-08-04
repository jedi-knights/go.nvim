-- lua/go/init.lua
-- Main plugin entry point for go.nvim

local M = {}

---Setup the plugin
---@param opts? go.Config Configuration options
---@param deps? table Dependencies for testing
---@return boolean success
function M.setup(opts, deps)
    deps = deps or {}
    local config = deps.config or require("go.config")
    return config.setup(opts, deps)
end

---Get current configuration
---@param deps? table Dependencies for testing
---@return go.Config config
function M.get_config(deps)
    deps = deps or {}
    local config = deps.config or require("go.config")
    return config.get(deps)
end

---Check if we should load the plugin
---@param deps? table Dependencies for testing
---@return boolean should_load
function M.should_load(deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    return detector.should_load(deps)
end

---Get project information
---@param deps? table Dependencies for testing
---@return go.ProjectInfo project_info
function M.get_project_info(deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    return detector.get_project_info(deps)
end

---Get environment information
---@param deps? table Dependencies for testing
---@return go.EnvironmentInfo env_info
function M.get_environment_info(deps)
    deps = deps or {}
    local detector = deps.detector or require("go.detector")
    return detector.get_environment_info(deps)
end

---Get module information
---@param deps? table Dependencies for testing
---@return go.ModuleInfo? module_info
function M.get_module_info(deps)
    deps = deps or {}
    local module = deps.module or require("go.module")
    return module.get_module_info(deps)
end

-- Task runner functions
---Run go-task task
---@param task_name string Name of the task to run
---@param args? table Arguments for the task
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_go_task(task_name, args, deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.run_go_task(task_name, args, deps)
end

---Run make target
---@param target string Target to run
---@param args? table Arguments for the target
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_make_target(target, args, deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.run_make_target(target, args, deps)
end

---Run custom script
---@param script_path string Path to the script
---@param args? table Arguments for the script
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_custom_script(script_path, args, deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.run_custom_script(script_path, args, deps)
end

---Re-run last task
---@param deps? table Dependencies for testing
---@return boolean success
function M.rerun_last_task(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.rerun_last_task(deps)
end

---Discover all available tasks
---@param deps? table Dependencies for testing
---@return table[] tasks
function M.discover_all_tasks(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.discover_all_tasks(deps)
end

---Show task picker
---@param deps? table Dependencies for testing
function M.show_task_picker(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    tasks.show_task_picker(deps)
end

---Show task history picker
---@param deps? table Dependencies for testing
function M.show_task_history_picker(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    tasks.show_history_picker(deps)
end

---Clear task history
---@param deps? table Dependencies for testing
function M.clear_task_history(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    tasks.clear_task_history(deps)
end

---Get task history
---@param deps? table Dependencies for testing
---@return table[] history
function M.get_task_history(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    return tasks.get_task_history(deps)
end

---Setup task runner keymaps
---@param deps? table Dependencies for testing
function M.setup_task_keymaps(deps)
    deps = deps or {}
    local tasks = deps.tasks or require("go.tasks")
    tasks.setup_task_keymaps(deps)
end

-- Package management functions
---Install package
---@param package_name string Name of the package to install
---@param deps? table Dependencies for testing
---@return boolean success
function M.install_package(package_name, deps)
    deps = deps or {}
    local package = deps.package or require("go.package")
    return package.install_package(package_name, deps)
end

---Uninstall package
---@param package_name string Name of the package to uninstall
---@param deps? table Dependencies for testing
---@return boolean success
function M.uninstall_package(package_name, deps)
    deps = deps or {}
    local package = deps.package or require("go.package")
    return package.uninstall_package(package_name, deps)
end

---List packages
---@param deps? table Dependencies for testing
---@return go.Package[] packages
function M.list_packages(deps)
    deps = deps or {}
    local package = deps.package or require("go.package")
    return package.list_packages(deps)
end

---Show package picker
---@param deps? table Dependencies for testing
function M.show_package_picker(deps)
    deps = deps or {}
    local package = deps.package or require("go.package")
    package.show_package_picker(deps)
end

-- Module management functions
---Create module
---@param module_name string Name of the module
---@param deps? table Dependencies for testing
---@return boolean success
function M.create_module(module_name, deps)
    deps = deps or {}
    local module = deps.module or require("go.module")
    return module.create_module(module_name, deps)
end

---Get module info
---@param deps? table Dependencies for testing
---@return go.ModuleInfo? module_info
function M.get_module_info(deps)
    deps = deps or {}
    local module = deps.module or require("go.module")
    return module.get_module_info(deps)
end

---Show module picker
---@param deps? table Dependencies for testing
function M.show_module_picker(deps)
    deps = deps or {}
    local module = deps.module or require("go.module")
    module.show_module_picker(deps)
end

-- Testing functions
---Run tests
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_tests(deps)
    deps = deps or {}
    local runner = deps.runner or require("go.runner")
    return runner.run_tests(deps)
end

---Run specific test
---@param test_name string Name of the test to run
---@param deps? table Dependencies for testing
---@return go.TestResult result
function M.run_test(test_name, deps)
    deps = deps or {}
    local runner = deps.runner or require("go.runner")
    return runner.run_test(test_name, deps)
end

---Show test picker
---@param deps? table Dependencies for testing
function M.show_test_picker(deps)
    deps = deps or {}
    local runner = deps.runner or require("go.runner")
    runner.show_test_picker(deps)
end

-- Formatting functions
---Format buffer
---@param deps? table Dependencies for testing
---@return boolean success
function M.format_buffer(deps)
    deps = deps or {}
    local formatter = deps.formatter or require("go.formatter")
    return formatter.format_buffer(deps)
end

---Format with specific formatter
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return boolean success
function M.format_with(formatter_name, deps)
    deps = deps or {}
    local formatter = deps.formatter or require("go.formatter")
    return formatter.format_with(formatter_name, deps)
end

-- Linting functions
---Lint buffer
---@param deps? table Dependencies for testing
---@return boolean success
function M.lint_buffer(deps)
    deps = deps or {}
    local linter = deps.linter or require("go.linter")
    return linter.lint_buffer(deps)
end

---Lint with specific linter
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return boolean success
function M.lint_with(linter_name, deps)
    deps = deps or {}
    local linter = deps.linter or require("go.linter")
    return linter.lint_with(linter_name, deps)
end

---Get linter status
---@param deps? table Dependencies for testing
---@return table status
function M.get_linter_status(deps)
    deps = deps or {}
    local linter = deps.linter or require("go.linter")
    return linter.get_linter_status(deps)
end

-- Import management functions
---Organize imports
---@param deps? table Dependencies for testing
---@return boolean success
function M.organize_imports(deps)
    deps = deps or {}
    local imports = deps.imports or require("go.imports")
    return imports.organize_imports(deps)
end

---Add import
---@param import_path string Import path to add
---@param alias? string Import alias
---@param deps? table Dependencies for testing
---@return boolean success
function M.add_import(import_path, alias, deps)
    deps = deps or {}
    local imports = deps.imports or require("go.imports")
    return imports.add_import(import_path, alias, deps)
end

---Remove unused imports
---@param deps? table Dependencies for testing
---@return boolean success
function M.remove_unused_imports(deps)
    deps = deps or {}
    local imports = deps.imports or require("go.imports")
    return imports.remove_unused_imports(deps)
end

---Show import picker
---@param deps? table Dependencies for testing
function M.show_import_picker(deps)
    deps = deps or {}
    local imports = deps.imports or require("go.imports")
    imports.show_import_picker(deps)
end

-- Coverage functions
---Run coverage
---@param deps? table Dependencies for testing
---@return boolean success
function M.run_coverage(deps)
    deps = deps or {}
    local coverage = deps.coverage or require("go.coverage")
    return coverage.run_coverage(deps)
end

---Show coverage report
---@param deps? table Dependencies for testing
---@return boolean success
function M.show_coverage_report(deps)
    deps = deps or {}
    local coverage = deps.coverage or require("go.coverage")
    return coverage.show_coverage_report(deps)
end

---Get coverage status
---@param deps? table Dependencies for testing
---@return table status
function M.get_coverage_status(deps)
    deps = deps or {}
    local coverage = deps.coverage or require("go.coverage")
    return coverage.get_coverage_status(deps)
end

-- Debugging functions
---Start debugging
---@param deps? table Dependencies for testing
---@return boolean success
function M.start_debugging(deps)
    deps = deps or {}
    local debugger = deps.debugger or require("go.debugger")
    return debugger.start_debugging(deps)
end

---Stop debugging
---@param deps? table Dependencies for testing
---@return boolean success
function M.stop_debugging(deps)
    deps = deps or {}
    local debugger = deps.debugger or require("go.debugger")
    return debugger.stop_debugging(deps)
end

---Get debugger status
---@param deps? table Dependencies for testing
---@return table status
function M.get_debugger_status(deps)
    deps = deps or {}
    local debugger = deps.debugger or require("go.debugger")
    return debugger.get_debugger_status(deps)
end

-- REPL functions
---Open REPL
---@param deps? table Dependencies for testing
---@return boolean success
function M.open_repl(deps)
    deps = deps or {}
    local repl = deps.repl or require("go.repl")
    return repl.open_repl(deps)
end

---Send to REPL
---@param code string Code to send to REPL
---@param deps? table Dependencies for testing
---@return boolean success
function M.send_to_repl(code, deps)
    deps = deps or {}
    local repl = deps.repl or require("go.repl")
    return repl.send_to_repl(code, deps)
end

---Get REPL status
---@param deps? table Dependencies for testing
---@return table status
function M.get_repl_status(deps)
    deps = deps or {}
    local repl = deps.repl or require("go.repl")
    return repl.get_repl_status(deps)
end

-- Utility functions
---Toggle debug mode
---@param deps? table Dependencies for testing
function M.toggle_debug(deps)
    deps = deps or {}
    local config = deps.config or require("go.config")
    config.toggle_debug(deps)
end

---Get debug status
---@param deps? table Dependencies for testing
---@return boolean debug_enabled
function M.get_debug_status(deps)
    deps = deps or {}
    local config = deps.config or require("go.config")
    return config.get_debug_status(deps)
end

---Get log level
---@param deps? table Dependencies for testing
---@return number log_level
function M.get_log_level(deps)
    deps = deps or {}
    local config = deps.config or require("go.config")
    return config.get_log_level(deps)
end

return M 