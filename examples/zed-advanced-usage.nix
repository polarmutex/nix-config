# Complete example configuration for Zed Advanced with wrapper-manager
# This demonstrates how to use the advanced Zed configuration system
# with your existing beancount and development setup

{ config, lib, pkgs, inputs, ... }:

let
  # Import language configurations
  languageConfigs = import ../modules/wrapper-manager/zed-advanced/languages.nix { inherit lib pkgs; };
  
  # Assuming you have beancount-language-server in your inputs
  beancountLsp = inputs.beancount-language-server.packages.${pkgs.system}.default or null;
  
in {
  imports = [
    # Import wrapper-manager
    inputs.wrapper-manager.homeManagerModules.default
    # Import the zed-advanced module
    ../modules/wrapper-manager/zed-advanced
  ];
  
  # Enable wrapper-manager
  programs.wrapper-manager.enable = true;
  
  # Configure Zed Advanced
  programs.zed-advanced = {
    enable = true;
    
    # Use the latest Zed package
    package = pkgs.zed-editor;
    
    # Comprehensive settings matching your current config
    settings = {
      # Core editor settings
      auto_update = false;
      vim_mode = true;
      relative_line_numbers = false;  # You had this disabled
      load_direnv = "shell_hook";
      
      # UI and appearance (matching your setup)
      theme = "Kanagawa Dragon";  # Your preferred theme
      ui_font_size = 18;
      buffer_font_size = 13;
      buffer_font_family = "Monolisa Custom";
      
      # Terminal configuration
      terminal = {
        font_family = "FiraCode Nerd Font Mono";
        blinking = "off";
      };
      
      # Vim configuration
      vim = {
        enable_vim_sneak = true;
        surround = true;
        exchange = true;
      };
      
      # Layout preferences
      active_pane_modifiers = {
        border_size = 3.0;
        inactive_opacity = 0.9;
      };
      
      centered_layout = {
        left_padding = 0.15;
        right_padding = 0.15;
      };
      
      # Panel configuration (matching your setup)
      project_panel = {
        indent_size = 16;
        button = true;
        dock = "right";
        git_status = true;
      };
      
      outline_panel = { dock = "right"; };
      notification_panel = { dock = "left"; };
      chat_panel = { dock = "left"; };
      collaboration_panel = { dock = "left"; };
      git_panel = { dock = "right"; };
      
      # Tab configuration
      tab_bar = {
        show = true;
        show_nav_history_buttons = false;
      };
      
      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "errors";
      };
      
      # File finder
      file_finder = { modal_width = "medium"; };
      
      # Editor behavior
      scrollbar = { show = "never"; };
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };
      
      indent_guides = {
        enabled = false;
        coloring = "indent_aware";
      };
      
      preferred_line_length = 120;
      tab_size = 4;
      
      # Productivity features
      format_on_save = "on";
      autosave = "on_focus_change";
      projects_online_by_default = true;
      
      # Diagnostics
      diagnostics = {
        inline = { enabled = true; };
      };
      
      # File handling
      file_scan_exclusions = [
        "**/.git"
        "**/node_modules"
        "**/dist"
        "**/out"
        "**/.vscode-test"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.next"
        "**/.storybook"
        "**/.nyc_output"
        "**/report"
        "**/target"
        "**/result"
        "**/.direnv"
      ];
      
      # File type associations
      file_types = languageConfigs.fileTypes;
      
      # Telemetry (disabled)
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      
      # Language configurations
      languages = languageConfigs.createLanguageConfigs {
        inherit beancountLsp;
        journalFile = "/home/polar/repos/personal/beancount/main/main.beancount";
      };
      
      # LSP configurations
      lsp = languageConfigs.createLspConfigs {
        inherit beancountLsp;
        journalFile = "/home/polar/repos/personal/beancount/main/main.beancount";
      };
    };
    
    # Custom keybindings (Vim-style with space leader)
    keymap = [
      {
        context = "Workspace";
        bindings = {
          # File operations
          "cmd-p" = "file_finder::Toggle";
          "cmd-shift-p" = "command_palette::Toggle";
          "cmd-shift-f" = "pane::SplitLeft";
          "cmd-t" = "tab_switcher::Toggle";
          
          # Panel toggles
          "cmd-b" = "workspace::ToggleLeftDock";
          "cmd-j" = "workspace::ToggleBottomDock";
        };
      }
      
      {
        context = "Editor && vim_mode == normal";
        bindings = {
          # Space-based leader key mappings (like your Neovim setup)
          "space-f-f" = "file_finder::Toggle";
          "space-f-g" = "pane::SplitLeft";
          "space-c-a" = "editor::ToggleCodeActions";
          "space-c-r" = "editor::Rename";
          
          # Go-to operations
          "g-d" = "editor::GoToDefinition";
          "g-r" = "editor::FindAllReferences";
          "g-i" = "editor::GoToImplementation";
          "g-t" = "editor::GoToTypeDefinition";
          
          # LSP operations
          "K" = "editor::Hover";
          "[d" = "editor::GoToPrevDiagnostic";
          "]d" = "editor::GoToNextDiagnostic";
          
          # Workspace operations
          "space-e" = "workspace::ToggleLeftDock";
          "space-t" = "terminal_panel::ToggleFocus";
        };
      }
      
      {
        context = "Editor && vim_mode == insert && !menu";
        bindings = {
          # Quick escape
          "j-k" = "vim::SwitchToNormalMode";
        };
      }
      
      {
        context = "Editor && showing_completions";
        bindings = {
          "ctrl-y" = "editor::ConfirmCompletion";
        };
      }
      
      {
        context = "Terminal";
        bindings = {
          "cmd-w" = "workspace::CloseActiveItem";
          "cmd-t" = "terminal_panel::AddPane";
        };
      }
    ];
    
    # Development tasks
    tasks = languageConfigs.defaultTasks // {
      # Beancount-specific tasks
      "beancount-check" = {
        command = "bean-check";
        args = ["\${ZED_BEANCOUNT_JOURNAL}"];
        working_directory = "./";
        hide = false;
      };
      
      "beancount-fava" = {
        command = "fava";
        args = ["\${ZED_BEANCOUNT_JOURNAL}"];
        working_directory = "./";
        hide = false;
      };
      
      # Nix-specific tasks for your config
      "nix-config-build" = {
        command = "nix";
        args = ["build" ".#nixosConfigurations.polarbear.config.system.build.toplevel"];
        working_directory = "/home/polar/repos/personal/nix-config/main";
        hide = false;
      };
      
      "nix-config-switch" = {
        command = "sudo";
        args = ["nixos-rebuild" "switch" "--flake" ".#polarbear"];
        working_directory = "/home/polar/repos/personal/nix-config/main";
        hide = false;
      };
    };
    
    # Extensions to bundle
    bundledExtensions = [
      # Core development extensions
      "rust"
      "nix"
      "python"
      "java"
      "toml"
      "dockerfile"
      "docker-compose"
      "makefile"
      
      # Git and productivity
      "git-firefly"
      
      # Formatting and linting
      "ruff"
      "prettier"
      
      # Additional languages you use
      "lua"
      "justfile"
      "xml"
      "asciidoc"
    ];
    
    # Additional language servers (beyond the defaults)
    extraLanguageServers = with pkgs; [
      # Java development
      maven
      gradle
      
      # Additional tools
      nodePackages.eslint
      nodePackages.stylelint
      
      # Beancount tools
      python3Packages.beancount
      python3Packages.fava
    ];
    
    # Beancount configuration (matching your current setup)
    beancountLsp = beancountLsp;
    journalFile = "/home/polar/repos/personal/beancount/main/main.beancount";
    
    # Environment variables
    environmentVariables = {
      # Logging
      ZED_LOG = "info";
      
      # Development paths
      ZED_DEFAULT_PROJECT_ROOT = "/home/polar/repos";
      
      # Beancount configuration
      ZED_BEANCOUNT_INCLUDES = "/home/polar/repos/personal/beancount/includes";
      
      # Rust development
      RUST_BACKTRACE = "1";
    };
  };
  
  # Include validation tools
  home.packages = let
    validation = import ../modules/wrapper-manager/zed-advanced/validation.nix { inherit lib pkgs; };
  in [
    (validation.createValidationScript { name = "validate-zed-advanced"; })
    (validation.createTestScript { name = "test-zed-advanced"; })
    (validation.createDevScript { name = "zed-dev-helper"; })
  ];
}

# Usage Instructions:
#
# 1. Add this to your home-manager configuration:
#    imports = [ ./examples/zed-advanced-usage.nix ];
#
# 2. Rebuild your home-manager configuration:
#    home-manager switch
#
# 3. Validate the installation:
#    validate-zed-advanced
#
# 4. Test the basic functionality:
#    test-zed-advanced
#
# 5. Start using Zed:
#    zed /path/to/your/project
#    # or with the alias:
#    zed-advanced /path/to/your/project
#
# Development helpers:
#   zed-dev-helper config      # Show configuration status
#   zed-dev-helper extensions  # List bundled extensions
#   zed-dev-helper lsp         # Check language servers
#   zed-dev-helper env         # Show environment variables
#
# What this gives you:
# - Zed configured exactly like your current setup
# - All extensions pre-installed and bundled
# - Language servers automatically available
# - Beancount language server integration
# - Vim mode with your preferred keybindings
# - Development tasks for common operations
# - Validation tools to ensure everything works
# - No auto-updates (managed by Nix instead)
# - Reproducible configuration across machines