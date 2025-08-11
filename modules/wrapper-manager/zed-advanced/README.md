# Zed Advanced - Wrapper-Manager Integration

A comprehensive Zed editor configuration system using wrapper-manager for Nix.

## Features

- 🎯 **Complete Configuration Management**: Settings, keymaps, tasks, and themes bundled in Nix store
- 📦 **Extension Bundling**: Pre-install extensions without network dependencies
- 🔧 **LSP Management**: Automatic language server setup and PATH management
- 🏃 **Performance**: Fast startup with pre-configured environment
- 🔒 **Immutable**: Configuration lives in read-only Nix store
- 🎨 **Customizable**: Extensive configuration options while maintaining sensible defaults
- 🧪 **Validated**: Built-in validation and testing tools

## Quick Start

### Basic Setup

Add to your `home.nix`:

```nix
{ inputs, ... }: {
  imports = [
    inputs.wrapper-manager.homeManagerModules.default
    ./modules/wrapper-manager/zed-advanced
  ];
  
  programs.wrapper-manager.enable = true;
  
  programs.zed-advanced = {
    enable = true;
    # Uses sensible defaults - you're ready to go!
  };
}
```

### Advanced Setup with Beancount

```nix
{ inputs, pkgs, ... }: {
  imports = [
    inputs.wrapper-manager.homeManagerModules.default
    ./modules/wrapper-manager/zed-advanced
  ];
  
  programs.wrapper-manager.enable = true;
  
  programs.zed-advanced = {
    enable = true;
    
    # Beancount integration
    beancountLsp = inputs.beancount-language-server.packages.${pkgs.system}.default;
    journalFile = "/home/user/accounting/main.beancount";
    
    # Customize settings
    settings = {
      theme = "Kanagawa Dragon";
      buffer_font_family = "JetBrains Mono";
      vim_mode = true;
    };
    
    # Add custom keybindings
    keymap = [
      {
        context = "Editor && vim_mode == normal";
        bindings = {
          "space-f-f" = "file_finder::Toggle";
          "space-c-a" = "editor::ToggleCodeActions";
        };
      }
    ];
    
    # Custom development tasks
    tasks = {
      "my-build" = {
        command = "make";
        args = ["build"];
        working_directory = "./";
      };
    };
  };
}
```

## Configuration Options

### Core Settings

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | `false` | Enable Zed Advanced |
| `package` | package | `pkgs.zed-editor` | Zed editor package |
| `settings` | attrs | `{}` | Zed settings.json content |
| `keymap` | list | `[]` | Custom key bindings |
| `tasks` | attrs | `{}` | Development tasks |

### Language Support

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `languages` | attrs | `{}` | Language-specific configurations |
| `lsp` | attrs | `{}` | LSP server configurations |
| `extraLanguageServers` | list | `[]` | Additional language servers |

### Extension Management

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `bundledExtensions` | list | Common extensions | Extensions to pre-install |
| `themes` | attrs | `{}` | Custom themes to bundle |

### Environment

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `environmentVariables` | attrs | `{}` | Custom environment variables |
| `beancountLsp` | package | `null` | Beancount language server |
| `journalFile` | path | `null` | Beancount journal file path |

## Default Features

### Language Support

Out of the box support for:

- **Rust**: rust-analyzer, clippy integration, cargo tasks
- **Python**: pyright + ruff, formatting, linting
- **Java**: jdtls, Maven/Gradle support
- **C/C++**: clangd, modern C++ standards
- **Nix**: nixd + nil, formatting with nixpkgs-fmt
- **JavaScript/TypeScript**: LSP, prettier formatting
- **Beancount**: Custom LSP integration (when configured)

### Pre-installed Extensions

- `rust` - Rust language support
- `nix` - Nix language support  
- `python` - Python development
- `java` - Java development
- `toml` - TOML file support
- `dockerfile` - Docker support
- `docker-compose` - Docker Compose
- `makefile` - Makefile support
- `git-firefly` - Enhanced git integration
- `ruff` - Python linting
- `prettier` - Code formatting

### Default Key Bindings

Vim-style bindings with space as leader key:

- `space-f-f` - File finder
- `space-c-a` - Code actions
- `space-c-r` - Rename symbol
- `g-d` - Go to definition
- `g-r` - Find references
- `K` - Show hover info
- `j-k` - Escape from insert mode

### Development Tasks

Pre-configured tasks for common operations:

- **Rust**: check, build, test, clippy
- **Python**: format, lint, test
- **Java**: build, test
- **C++**: build, clean
- **Nix**: build, format
- **Docker**: build, compose up
- **Git**: status, diff

## Validation Tools

The module includes comprehensive validation tools:

```bash
# Full validation suite
validate-zed-advanced

# Quick test
test-zed-advanced

# Development helper
zed-dev-helper config      # Show configuration
zed-dev-helper extensions  # List extensions
zed-dev-helper lsp         # Check language servers
zed-dev-helper env         # Show environment
```

## File Structure

```
modules/wrapper-manager/zed-advanced/
├── default.nix          # Main module
├── languages.nix        # Language configurations
├── validation.nix       # Testing and validation tools
├── integration.nix      # Easy integration helpers
└── README.md           # This file
```

## How It Works

### Wrapper-Manager Integration

1. **Configuration Bundle**: All config files are generated in Nix store
2. **Environment Variables**: `XDG_CONFIG_HOME` and `XDG_DATA_HOME` point to bundles
3. **PATH Management**: Language servers automatically added to PATH
4. **Extension Pre-installation**: Extensions "installed" without network access

### Environment Variables Set

- `XDG_CONFIG_HOME` → Nix store configuration bundle
- `XDG_DATA_HOME` → Nix store extensions bundle
- `ZED_DISABLE_AUTO_UPDATE=1` → Prevent conflicts with Nix management
- `ZED_BEANCOUNT_JOURNAL` → Path to beancount journal (if configured)
- `ZED_LOG=info` → Logging level

### Directory Structure Created

```
$XDG_CONFIG_HOME/zed/
├── settings.json     # Generated from Nix config
├── keymap.json      # Generated from Nix config
├── tasks.json       # Generated from Nix config
└── themes/         # Custom themes (if any)

$XDG_DATA_HOME/extensions/
├── installed/       # Pre-installed extensions
│   ├── rust/
│   ├── nix/
│   ├── python/
│   └── ...
└── work/           # Extension work directory
```

## Migration from Standard Zed

### From Existing Zed Config

1. **Backup your current config**:
   ```bash
   cp -r ~/.config/zed ~/.config/zed.backup
   ```

2. **Convert settings to Nix**:
   ```nix
   programs.zed-advanced.settings = {
     # Paste your existing settings.json content here
     theme = "your-theme";
     vim_mode = true;
     # ... etc
   };
   ```

3. **Convert keybindings**:
   ```nix
   programs.zed-advanced.keymap = [
     # Convert your keymap.json content
   ];
   ```

4. **Add language servers**:
   Language servers are automatically included, but you can add more:
   ```nix
   programs.zed-advanced.extraLanguageServers = with pkgs; [
     # additional servers
   ];
   ```

### From Neovim

The default configuration provides a Neovim-like experience:

- Vim mode enabled by default
- Space-based leader key mappings
- LSP integration similar to nvim-lspconfig
- File finder similar to telescope
- Git integration

## Troubleshooting

### Configuration Issues

```bash
# Validate your configuration
validate-zed-advanced

# Check if config files are properly generated
zed-dev-helper config
```

### LSP Issues

```bash
# Check which language servers are available
zed-dev-helper lsp

# Check if specific LSP is in PATH
which rust-analyzer
```

### Extension Issues

```bash
# List bundled extensions
zed-dev-helper extensions

# Check extensions directory
ls -la $XDG_DATA_HOME/extensions/installed/
```

### Environment Issues

```bash
# Check environment variables
zed-dev-helper env

# Verify paths
echo $XDG_CONFIG_HOME
echo $XDG_DATA_HOME
```

## Examples

See `examples/zed-advanced-usage.nix` for a complete configuration example that matches a typical Neovim setup with beancount integration.

## Contributing

When adding new features:

1. Update the module options in `default.nix`
2. Add language configurations to `languages.nix`
3. Update validation tools in `validation.nix`
4. Add examples to the examples directory
5. Update this README

## License

This module is part of the nix-config repository and follows the same license terms.