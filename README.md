# go.nvim

A comprehensive Neovim plugin that provides quality-of-life functionality for Go development. Designed to work seamlessly with any Neovim distribution while providing powerful Go-specific features.

## ✨ Features

### 🐹 **Core Go Development**
- **Go Module Management**: Auto-detect and manage Go modules
- **Package Management**: Install, update, and manage Go packages
- **Import Management**: Organize and clean up imports automatically
- **Code Formatting**: Integrated formatting with gofmt, goimports
- **Linting**: Real-time linting with golint, staticcheck, and revive

### 🧪 **Testing & Debugging**
- **Test Discovery**: Automatically find and run tests
- **Test Runner**: Execute tests with go test, testify, and ginkgo
- **Debug Integration**: Seamless debugging with delve
- **Coverage**: View test coverage reports inline
- **Test Navigation**: Jump between test files and implementations

### 📦 **Project Management**
- **Project Detection**: Auto-detect Go projects and their structure
- **Dependency Management**: Manage go.mod, go.sum, and vendor
- **Module Switching**: Switch between different Go modules
- **Project Templates**: Create new Go projects with templates

### 🔍 **Code Intelligence**
- **Symbol Navigation**: Navigate packages, functions, and imports
- **Refactoring**: Safe refactoring operations
- **Documentation**: Generate and view godoc
- **Type Hints**: Enhanced type hint support and validation
- **Code Actions**: Quick fixes and code improvements

### 🛠 **Development Tools**
- **REPL Integration**: Interactive Go REPL in floating terminal
- **Package Explorer**: Browse installed packages and their documentation
- **Module Inspector**: Inspect current Go module
- **Performance Profiling**: Profile Go code execution

### 🚀 **Task Runner Integration**
- **Go Task Support**: Execute go-task tasks with interactive pickers
- **Task Discovery**: Automatically find available tasks
- **Task History**: Track and re-run previous tasks
- **Multi-Runner Support**: Support for go-task, make, and custom scripts

## 📦 Requirements

- **Neovim >= 0.8**
- **Go 1.16+**
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Required for async operations
- **[snacks.nvim](https://github.com/folke/snacks.nvim)** - For interactive pickers (optional but recommended)

## 🚀 Installation

### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jedi-knights/go.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim", -- Optional but recommended
  },
  event = { "BufReadPre *.go", "BufNewFile *.go" },
  config = function()
    require("go").setup()
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "jedi-knights/go.nvim",
  requires = { 
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    require("go").setup()
  end,
})
```

## ⚙️ Configuration

### Basic Setup

```lua
require("go").setup({
  -- Core settings
  go_command = "go",
  enable_module_support = true,
  auto_detect_modules = true,
  
  -- Formatting
  formatters = {
    gofmt = { enabled = true },
    goimports = { enabled = true },
    golines = { enabled = false },
  },
  
  -- Linting
  linters = {
    golint = { enabled = true },
    staticcheck = { enabled = true },
    revive = { enabled = false },
  },
  
  -- Testing
  test_frameworks = {
    go_test = { enabled = true },
    testify = { enabled = true },
    ginkgo = { enabled = false },
  },
  
  -- Task running
  task_runner = {
    enabled = true,
    go_task = { enabled = true },
    make = { enabled = true },
    scripts = { enabled = true },
  },
  
  -- UI
  enable_floating_terminals = true,
  enable_notifications = true,
  enable_debugging = true,
})
```

### Advanced Configuration

```lua
require("go").setup({
  -- Module management
  modules = {
    default = "go.mod",
    auto_create = true,
    auto_detect = true,
    mod_path = "go.mod",
  },
  
  -- Package management
  package_manager = "go", -- or "gopls"
  auto_install_deps = true,
  
  -- Code intelligence
  enable_import_sorting = true,
  enable_auto_import = true,
  enable_type_checking = true,
  
  -- Testing
  test_coverage = {
    enabled = true,
    tool = "go", -- or "gocov"
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
})
```

## 🎯 Usage

### Core Commands

| Command | Description |
|---------|-------------|
| `:GoSetup` | Setup Go environment for current project |
| `:GoModule` | Manage Go modules |
| `:GoInstall` | Install Go packages |
| `:GoFormat` | Format current buffer |
| `:GoLint` | Lint current buffer |
| `:GoTest` | Run tests |
| `:GoDebug` | Start debugging session |
| `:GoREPL` | Open Go REPL |

### Keymaps (Default)

| Keymap | Description |
|--------|-------------|
| `<leader>gm` | Open module picker |
| `<leader>gi` | Install package |
| `<leader>gu` | Update package |
| `<leader>gf` | Format buffer |
| `<leader>gl` | Lint buffer |
| `<leader>gt` | Run tests |
| `<leader>gd` | Start debugging |
| `<leader>gr` | Open REPL |

### Interactive Pickers

- **Module Picker**: `:GoModulePicker` - Switch between Go modules
- **Package Picker**: `:GoPackagePicker` - Browse and manage packages
- **Test Picker**: `:GoTestPicker` - Discover and run tests
- **Import Picker**: `:GoImportPicker` - Organize imports
- **Task Picker**: `:GoTask` - Discover and run tasks (go-task, make, scripts)

## 🏗️ Architecture

```
go.nvim/
├── lua/go/
│   ├── init.lua              # Main plugin entry point
│   ├── config.lua            # Configuration management
│   ├── types.lua             # Type definitions
│   ├── detector.lua          # Project and environment detection
│   ├── commands.lua          # User commands
│   ├── ui.lua               # UI components and pickers
│   ├── runner.lua           # Code execution and testing
│   ├── formatter.lua        # Code formatting
│   ├── linter.lua           # Code linting
│   ├── debugger.lua         # Debugging integration
│   ├── repl.lua             # REPL management
│   ├── package.lua          # Package management
│   ├── module.lua           # Module management
│   ├── imports.lua          # Import management
│   ├── coverage.lua         # Test coverage
│   ├── tasks.lua            # Task runner (go-task, make, scripts)
│   └── utils.lua            # Utility functions
├── plugin/go.lua            # Plugin bootstrap
└── README.md               # This file
```

## 🔧 Development

### Adding New Features

1. **Follow DRY principles**: Extract common functionality into reusable modules
2. **Use dependency injection**: Make functions testable with `deps` parameter
3. **Implement proper error handling**: Use `pcall` and provide helpful error messages
4. **Add comprehensive documentation**: Document all public APIs
5. **Write tests**: Include unit tests for new functionality

### Testing

```bash
# Run tests
nvim --headless -c "lua require('plenary.test_harness').test_directory('tests', { minimal_init = 'tests/minimal_init.lua' })"
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the established code patterns
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

---

**Made with ❤️ for the Go and Neovim communities**
