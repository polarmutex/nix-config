# Example configuration for using the Zed editor module
# Add this to your NixOS configuration to enable Zed with nix-maid integration

{ config, lib, pkgs, ... }:

{
  # Import the Zed module (automatically available through flake.nixosModules)
  # No manual import needed - just configure the service

  # Basic Zed configuration with defaults
  services.zed = {
    enable = true;
    # Uses default package (pkgs.zed-editor)
    # Enables Rust development tools by default
    # Enables nix-maid integration by default
    # Uses sensible default configuration
  };

  # Or customize the configuration:
  # services.zed = {
  #   enable = true;
  #   package = pkgs.zed-editor;  # Customize the package if needed
  #   enableRustDevelopment = true;  # Install rustup, cargo, etc.
  #   enableNixMaid = true;  # Use nix-maid for configuration management
  #   defaultConfiguration = true;  # Use sensible defaults
  #   
  #   # Add custom configuration files
  #   configurationFiles = {
  #     "tasks.json" = ''
  #       {
  #         "tasks": [
  #           {
  #             "label": "cargo build",
  #             "command": "cargo",
  #             "args": ["build"]
  #           }
  #         ]
  #       }
  #     '';
  #     "themes/custom-theme.json" = ''
  #       {
  #         "name": "Custom Theme",
  #         "appearance": "dark",
  #         "style": {}
  #       }
  #     '';
  #   };
  # };
}

# What this module provides:
#
# 1. Zed Editor Installation:
#    - Installs zed-editor package system-wide
#    - Includes xdg-utils for proper desktop integration
#
# 2. Rust Development Environment:
#    - rustup for managing Rust toolchains
#    - rust-analyzer for LSP support
#    - cargo, clippy, rustfmt for development tools
#    - patchelf and clang-tools for native development
#    - RUST_SRC_PATH environment variable
#    - nix-ld for dynamic linking support
#
# 3. nix-maid Integration:
#    - Automatic configuration file management
#    - Declarative configuration through Nix
#    - Configuration files placed in ~/.config/zed/
#
# 4. Default Configuration Includes:
#    - Tokyo Night theme (dark/light based on system)
#    - Vim mode enabled
#    - Essential extensions auto-installed (nix, rust, lua, etc.)
#    - Sensible editor settings (tab size, fonts, etc.)
#    - LSP configuration for Nix and Rust
#    - Custom keybindings for common operations
#
# 5. Configuration Management:
#    - All configuration managed through nix-maid
#    - Files automatically updated when configuration changes
#    - No manual configuration file editing needed
#
# To use this in your NixOS configuration:
# 1. Add the configuration above to your system configuration
# 2. Run `sudo nixos-rebuild switch`
# 3. Zed will be installed with configuration managed by nix-maid
# 4. Start developing Rust extensions with the pre-configured environment