-- lua/go/types.lua
-- Type definitions for go.nvim

---@class go.Config
---@field go_command string Go command to use (default: "go")
---@field enable_module_support boolean Enable module support (default: true)
---@field auto_detect_modules boolean Auto-detect modules (default: true)
---@field formatters go.FormatterConfig Configuration for code formatters
---@field linters go.LinterConfig Configuration for code linters
---@field test_frameworks go.TestFrameworkConfig Configuration for test frameworks
---@field task_runner go.TaskRunnerConfig Configuration for task runners
---@field modules go.ModuleConfig Configuration for module management
---@field package_manager string Package manager to use (default: "go")
---@field auto_install_deps boolean Auto-install dependencies (default: true)
---@field enable_import_sorting boolean Enable import sorting (default: true)
---@field enable_auto_import boolean Enable auto-import (default: true)
---@field enable_type_checking boolean Enable type checking (default: true)
---@field test_coverage go.CoverageConfig Configuration for test coverage
---@field debugger go.DebuggerConfig Configuration for debugging
---@field repl go.ReplConfig Configuration for REPL
---@field enable_floating_terminals boolean Enable floating terminals (default: true)
---@field enable_notifications boolean Enable notifications (default: true)
---@field enable_debugging boolean Enable debugging (default: true)
---@field log_level number Log level (default: vim.log.levels.INFO)
---@field debug boolean Enable debug mode (default: false)

---@class go.FormatterConfig
---@field gofmt go.FormatterSettings Gofmt settings
---@field goimports go.FormatterSettings Goimports settings
---@field golines go.FormatterSettings Golines settings

---@class go.FormatterSettings
---@field enabled boolean Whether the formatter is enabled
---@field args? string[] Additional arguments for the formatter

---@class go.LinterConfig
---@field golint go.LinterSettings Golint settings
---@field staticcheck go.LinterSettings Staticcheck settings
---@field revive go.LinterSettings Revive settings

---@class go.LinterSettings
---@field enabled boolean Whether the linter is enabled
---@field args? string[] Additional arguments for the linter

---@class go.TestFrameworkConfig
---@field go_test go.TestFrameworkSettings Go test settings
---@field testify go.TestFrameworkSettings Testify settings
---@field ginkgo go.TestFrameworkSettings Ginkgo settings

---@class go.TestFrameworkSettings
---@field enabled boolean Whether the test framework is enabled
---@field args? string[] Additional arguments for the test framework

---@class go.TaskRunnerConfig
---@field enabled boolean Whether task running is enabled
---@field go_task go.TaskRunnerSettings Go-task settings
---@field make go.TaskRunnerSettings Make settings
---@field scripts go.TaskRunnerSettings Script settings

---@class go.TaskRunnerSettings
---@field enabled boolean Whether the task runner is enabled
---@field args? string[] Additional arguments for the task runner

---@class go.ModuleConfig
---@field default string Default module file (default: "go.mod")
---@field auto_create boolean Auto-create modules (default: true)
---@field auto_detect boolean Auto-detect modules (default: true)
---@field mod_path string Module file path (default: "go.mod")

---@class go.CoverageConfig
---@field enabled boolean Whether coverage is enabled
---@field tool string Coverage tool to use (default: "go")
---@field show_inline boolean Show inline coverage (default: true)

---@class go.DebuggerConfig
---@field enabled boolean Whether debugging is enabled
---@field adapter string Debug adapter to use (default: "delve")
---@field port number Debug port (default: 2345)

---@class go.ReplConfig
---@field enabled boolean Whether REPL is enabled
---@field floating boolean Use floating window (default: true)
---@field auto_import boolean Auto-import packages (default: true)

---@class go.Task
---@field name string Task name
---@field desc string Task description
---@field runner_type string Task runner type (go_task, make, script)

---@class go.Module
---@field name string Module name
---@field path string Module path
---@field version string Module version
---@field replace? string Replace directive

---@class go.Package
---@field name string Package name
---@field path string Package path
---@field version string Package version
---@field latest? string Latest available version

---@class go.TestResult
---@field name string Test name
---@field status string Test status (passed, failed, skipped)
---@field duration number Test duration in seconds
---@field output string Test output
---@field error? string Test error message

---@class go.CoverageResult
---@field file string File path
---@field coverage number Coverage percentage
---@field lines_covered number Number of covered lines
---@field lines_total number Total number of lines
---@field uncovered_lines number[] List of uncovered line numbers

---@class go.Import
---@field name string Import name
---@field path string Import path
---@field alias? string Import alias
---@field used boolean Whether the import is used

---@class go.LinterResult
---@field file string File path
---@field line number Line number
---@field column number Column number
---@field message string Linter message
---@field severity string Severity level (error, warning, info)
---@field linter string Linter name

---@class go.FormatterResult
---@field file string File path
---@field formatted boolean Whether the file was formatted
---@field changes? string[] List of changes made

---@class go.PickerItem
---@field text string Display text
---@field value any Item value
---@field desc? string Item description

---@class go.RunnerOptions
---@field silent? boolean Run silently (default: false)
---@field args? string[] Additional arguments
---@field cwd? string Working directory
---@field env? table<string, string> Environment variables

---@class go.ProjectInfo
---@field root string Project root directory
---@field is_go_project boolean Whether this is a Go project
---@field has_go_mod boolean Whether go.mod exists
---@field has_go_sum boolean Whether go.sum exists
---@field has_vendor boolean Whether vendor directory exists
---@field module_name? string Go module name
---@field go_version? string Go version

---@class go.EnvironmentInfo
---@field go_path string Go executable path
---@field go_version string Go version
---@field gopath string GOPATH
---@field goroot string GOROOT
---@field available boolean Whether Go is available

---@class go.ModuleInfo
---@field path string Module path
---@field name string Module name
---@field version string Module version
---@field go_version string Go version used
---@field dependencies go.Module[] Module dependencies
---@field replace_directives go.Module[] Replace directives
---@field active boolean Whether the module is active

---@class go.TaskHistory
---@field cmd string[] Command that was run
---@field runner_type string Type of runner (go_task, make, script)
---@field task_name string Name of the task
---@field timestamp number Timestamp when task was run
---@field exit_code? number Exit code of the task
---@field output? string Task output

---@class go.DebugSession
---@field id string Session ID
---@field adapter string Debug adapter
---@field port number Debug port
---@field program string Program being debugged
---@field args string[] Program arguments
---@field cwd string Working directory
---@field active boolean Whether the session is active
---@field breakpoints go.Breakpoint[] List of breakpoints

---@class go.Breakpoint
---@field id number Breakpoint ID
---@field file string File path
---@field line number Line number
---@field condition? string Conditional expression
---@field hit_count number Number of times hit
---@field enabled boolean Whether the breakpoint is enabled

---@class go.ReplSession
---@field id string Session ID
---@field buffer number Buffer number
---@field window number Window number
---@field active boolean Whether the session is active
---@field history string[] Command history
---@field auto_import boolean Whether auto-import is enabled 