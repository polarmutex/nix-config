# Modern Bash with Fish-like Features

## Overview

Modern Bash is a Nix package that enhances the traditional bash shell with popular features from the fish shell, providing a more user-friendly and productive command-line experience.

## Features Implemented

### 🚀 Command Abbreviations
Fish-style abbreviations that expand automatically:
- `g` → `git`
- `ga` → `git add` 
- `gc` → `git commit`
- `gco` → `git checkout`
- `gd` → `git diff`
- `gl` → `git log`
- `gp` → `git push`
- `gs` → `git status`
- `ll` → `ls -la`
- `la` → `ls -A`
- `l` → `ls -CF`
- `..` → `cd ..`
- `...` → `cd ../..`
- `....` → `cd ../../..`

### 📚 Enhanced History Management
- **Increased history size**: 10,000 commands in memory, 20,000 in file
- **Smart deduplication**: Eliminates duplicate commands
- **fzf integration**: Ctrl+R for fuzzy history search
- **Timestamped history**: Each command includes execution time
- **Shared history**: Commands shared across all bash sessions

### 🎯 Smart Tab Completion
- **Case-insensitive completion**: Type in any case, get correct matches
- **Fuzzy file completion**: Partial matches work (e.g., `fbr` matches `foobar`)
- **Menu completion**: Cycle through matches with Tab/Shift+Tab
- **Git-aware completion**: Enhanced git command completion

### 📁 Intelligent Directory Navigation
- **Smart cd**: Automatically finds directories with partial matches
- **Directory shortcuts**: `d` to view directory stack, `pu`/`po` for pushd/popd
- **Auto-correction**: Fixes common typos in directory names
- **Enhanced globbing**: Better pattern matching with `**` support

### 🎨 Modern Prompt
- **Git integration**: Shows current branch and status (*, +)
- **Colorized output**: Different colors for user, host, path, and git info
- **Shortened paths**: Long paths are abbreviated for readability

### ⌨️ Enhanced Vi Mode
- **Visual mode indicators**: Shows insert/command mode in prompt
- **Better key bindings**: Improved navigation and editing
- **Command line editing**: `v` in command mode opens editor

### 🔧 Shell Improvements
- **Better globbing**: `shopt -s globstar nullglob`
- **Spell correction**: Auto-corrects directory and command names
- **Enhanced aliases**: Color-aware ls, grep, and other commands
- **Command-not-found**: Suggests similar commands when command not found

## Installation

### Using Nix Flakes
Add to your `flake.nix` inputs:
```nix
inputs.your-config.url = "github:polarmutex/nix-config";
```

Then in your system packages:
```nix
environment.systemPackages = [
  inputs.your-config.packages.${system}.modern-bash
];
```

### Direct Build
```bash
nix build .#packages.x86_64-linux.modern-bash
```

## Usage

### Start Modern Bash
```bash
modern-bash
```

### Setup for Existing Bash
```bash
setup-modern-bash
```
This will backup your current `.bashrc` and add modern bash features.

### Nix-Maid Integration
The package includes nix-maid wrapper configuration for enhanced deployment:

```nix
# In your configuration
wrappers.modern-bash.enable = true;
```

## Configuration Options (via Nix-Maid)

### Home Manager Module
```nix
programs.modern-bash = {
  enable = true;
  enableAutosuggestions = true;
  enableSyntaxHighlighting = true;
  enableFuzzyCompletion = true;
  enableAbbreviations = true;
  enableViMode = false;  # Optional vi mode
  
  customAbbreviations = {
    "gco" = "git checkout";
    "gst" = "git status";
    "ll" = "ls -la";
  };
  
  shellAliases = {
    "grep" = "grep --color=auto";
    "ls" = "ls --color=auto";
  };
  
  extraConfig = ''
    # Additional bash configuration
    export EDITOR=vim
  '';
};
```

### Wrapper Manager Module
```nix
wrappers.modern-bash = {
  enable = true;
  enableDebug = false;
  extraArgs = ["--login"];
  
  environmentVariables = {
    "MODERN_BASH_THEME" = "default";
  };
  
  preExec = ''
    echo "Starting Modern Bash..."
  '';
};
```

## Key Bindings

### Standard Mode
- `Ctrl+R`: Fuzzy history search with fzf
- `Ctrl+L`: Clear screen
- `Tab`: Menu completion (cycle forward)
- `Shift+Tab`: Menu completion (cycle backward)
- `Ctrl+F`: Accept autosuggestion (when available)

### Vi Mode (if enabled)
- `Escape`: Enter command mode
- `v`: Edit command line in editor (command mode)
- `i/a`: Enter insert mode
- Standard vi navigation: `h`, `j`, `k`, `l`, `w`, `b`

## Environment Variables

- `MODERN_BASH_AUTOSUGGESTIONS=1`: Enable autosuggestions
- `MODERN_BASH_SYNTAX_HIGHLIGHTING=1`: Enable syntax highlighting  
- `MODERN_BASH_FUZZY_COMPLETION=1`: Enable fuzzy completion
- `MODERN_BASH_VI_MODE=1`: Enable vi mode
- `MODERN_BASH_ABBREVIATIONS=1`: Enable abbreviations

## Troubleshooting

### Line Editing Warnings
If you see "line editing not enabled" warnings, this is normal for non-interactive shells. The features will work properly in interactive mode.

### fzf Not Found
Install fzf for enhanced history search:
```bash
nix-shell -p fzf
```

### Git Completion Issues
Ensure git is installed and accessible in your PATH.

## Architecture

The package is structured as:
- **Core package**: `packages/modern-bash.nix`
- **Home Manager module**: `modules/maid/modern-bash.nix`  
- **Wrapper Manager module**: `modules/wrapper-manager/modern-bash.nix`

Each component provides different levels of integration:
1. **Core**: Basic package installation
2. **Home Manager**: User-level configuration and integration
3. **Wrapper Manager**: Enhanced deployment with nix-maid

## Contributing

The modern-bash package is part of the larger nix-config repository. Contributions are welcome for:
- Additional fish-like features
- Better error handling
- Performance improvements
- Documentation enhancements

## License

MIT License - see the package metadata for full details.