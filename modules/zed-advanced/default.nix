{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.zed-advanced;

  # Create configuration bundle in Nix store
  configBundle = pkgs.runCommand "zed-config-bundle" {} ''
    mkdir -p $out/zed

    # Generate settings.json
    cat > $out/zed/settings.json << 'EOF'
    ${builtins.toJSON cfg.settings}
    EOF

    # Generate keymap.json
    cat > $out/zed/keymap.json << 'EOF'
    ${builtins.toJSON cfg.keymap}
    EOF

    # Generate tasks.json
    cat > $out/zed/tasks.json << 'EOF'
    ${builtins.toJSON cfg.tasks}
    EOF

    # Copy themes if provided
    ${lib.optionalString (cfg.themes != {}) ''
      mkdir -p $out/zed/themes
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: content: ''
          cat > $out/zed/themes/${name} << 'EOF'
          ${builtins.toJSON content}
          EOF
        '')
        cfg.themes)}
    ''}
  '';

  # Create extensions bundle
  extensionsBundle =
    pkgs.runCommand "zed-extensions-bundle" {
      buildInputs = [pkgs.jq];
    } ''
      mkdir -p $out/extensions/installed
      mkdir -p $out/extensions/work

      # Pre-create extension directories for bundled extensions
      ${lib.concatStringsSep "\n" (map (ext: ''
          mkdir -p $out/extensions/installed/${ext}
          # Create manifest for extension
          cat > $out/extensions/installed/${ext}/extension.json << 'EOF'
          {
            "id": "${ext}",
            "name": "${ext}",
            "version": "bundled-via-nix-1.0.0",
            "schema_version": 1,
            "bundled": true,
            "source": "nix-wrapper"
          }
          EOF
        '')
        cfg.bundledExtensions)}

      # Create extensions index
      cat > $out/extensions/installed/index.json << 'EOF'
      {
        "extensions": [
          ${lib.concatStringsSep ",\n" (map (
          extName: ''
            {
              "id": "${extName}",
              "name": "${extName}",
              "installed_via_nix": true,
              "status": "bundled"
            }''
        )
        cfg.bundledExtensions)}
        ],
        "bundled_count": ${toString (builtins.length cfg.bundledExtensions)},
        "managed_by": "nix-wrapper-manager"
      }
      EOF
    '';

  # Language servers and tools for PATH
  languageServers = with pkgs;
    [
      # Core language servers
      rust-analyzer
      clang-tools
      nixd
      nil

      # Python ecosystem
      pyright
      ruff
      python3Packages.python-lsp-server

      # Web development
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier

      # Java
      jdt-language-server

      # Additional tools
      fd
      ripgrep
      fzf
    ]
    ++ cfg.extraLanguageServers ++ (lib.optional (cfg.beancountLsp != null) cfg.beancountLsp);

  # Import language configurations
  languageConfigs = import ./languages.nix {inherit lib pkgs;};

  # Default settings configuration
  defaultSettings = {
    # Core editor settings
    auto_update = false;
    vim_mode = true;
    relative_line_numbers = true;
    load_direnv = "shell_hook";

    # UI and appearance
    theme = "Kanagawa Dragon";
    ui_font_size = 18;
    buffer_font_size = 13;
    buffer_font_family = "Monolisa Custom";

    # Vim configuration
    vim = {
      enable_vim_sneak = true;
      surround = true;
      exchange = true;
    };

    # Layout
    active_pane_modifiers = {
      border_size = 3.0;
      inactive_opacity = 0.9;
    };

    project_panel = {
      indent_size = 16;
      button = true;
      dock = "right";
      git_status = true;
    };

    outline_panel = {dock = "right";};
    git_panel = {dock = "right";};

    # Productivity features
    inlay_hints = {
      enabled = true;
      show_type_hints = true;
      show_parameter_hints = true;
      show_other_hints = true;
    };

    format_on_save = "on";
    autosave = "on_focus_change";

    # File handling
    file_scan_exclusions = [
      "**/.git"
      "**/node_modules"
      "**/dist"
      "**/out"
      "**/target"
      "**/result"
      "**/.direnv"
      "**/.vscode-test"
      "**/.DS_Store"
      "**/Thumbs.db"
    ];

    # File type associations
    file_types = languageConfigs.fileTypes;

    # Telemetry
    telemetry = {
      diagnostics = false;
      metrics = false;
    };

    # Terminal
    terminal = {
      font_family = "FiraCode Nerd Font Mono";
      blinking = "off";
    };

    # Language-specific configurations (merge with user config)
    languages =
      (languageConfigs.createLanguageConfigs {
        beancountLsp = cfg.beancountLsp;
        journalFile = cfg.journalFile;
      })
      // cfg.languages;

    # LSP configurations (merge with user config)
    lsp =
      (languageConfigs.createLspConfigs {
        beancountLsp = cfg.beancountLsp;
        journalFile = cfg.journalFile;
      })
      // cfg.lsp;

    # Auto-install extensions
    auto_install_extensions = lib.listToAttrs (map (ext: {
        name = ext;
        value = true;
      })
      cfg.bundledExtensions);
  };

  # Default keymap configuration
  defaultKeymap = [
    {
      context = "Workspace";
      bindings = {
        "cmd-p" = "file_finder::Toggle";
        "cmd-shift-p" = "command_palette::Toggle";
        "cmd-shift-f" = "pane::SplitLeft";
        "cmd-t" = "tab_switcher::Toggle";
        "cmd-b" = "workspace::ToggleLeftDock";
        "cmd-j" = "workspace::ToggleBottomDock";
      };
    }

    {
      context = "Editor && vim_mode == normal";
      bindings = {
        "space-f-f" = "file_finder::Toggle";
        "space-f-g" = "pane::SplitLeft";
        "space-c-a" = "editor::ToggleCodeActions";
        "space-c-r" = "editor::Rename";
        "g-d" = "editor::GoToDefinition";
        "g-r" = "editor::FindAllReferences";
        "K" = "editor::Hover";
      };
    }

    {
      context = "Editor && vim_mode == insert && !menu";
      bindings = {
        "j-k" = "vim::SwitchToNormalMode";
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
in {
  options.programs.zed-advanced = {
    enable = mkEnableOption "Zed editor with advanced wrapper-manager integration";

    package = mkOption {
      type = types.package;
      default = pkgs.zed-editor;
      description = "Base Zed editor package";
    };

    settings = mkOption {
      type = types.attrs;
      default = defaultSettings;
      description = "Zed settings.json content";
    };

    keymap = mkOption {
      type = types.listOf types.attrs;
      default = defaultKeymap;
      description = "Zed keymap.json content";
    };

    tasks = mkOption {
      type = types.attrs;
      default = {};
      description = "Zed tasks.json content";
    };

    themes = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = "Custom themes to bundle";
    };

    bundledExtensions = mkOption {
      type = types.listOf types.str;
      default = [
        "rust"
        "nix"
        "python"
        "java"
        "toml"
        "dockerfile"
        "docker-compose"
        "makefile"
        "git-firefly"
        "ruff"
        "prettier"
      ];
      description = "Extensions to pre-install in bundle";
    };

    languages = mkOption {
      type = types.attrs;
      default = {};
      description = "Language-specific configurations";
    };

    lsp = mkOption {
      type = types.attrs;
      default = {};
      description = "LSP server configurations";
    };

    extraLanguageServers = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional language servers to add to PATH";
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Additional environment variables to set";
    };

    beancountLsp = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "Beancount language server package";
    };

    journalFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to beancount journal file";
    };
  };

  config = mkIf cfg.enable {
    programs.wrapper-manager.zed-advanced = {
      basePackage = cfg.package;

      # Environment variables for configuration
      env =
        {
          # Point Zed to our bundled configuration
          XDG_CONFIG_HOME.value = configBundle;
          XDG_DATA_HOME.value = extensionsBundle;

          # Disable auto-updates since we manage via Nix
          ZED_DISABLE_AUTO_UPDATE.value = "1";
          ZED_DISABLE_EXTENSION_AUTO_UPDATE.value = "1";

          # Logging
          ZED_LOG.value = "info";
        }
        // (lib.mapAttrs (name: value: {inherit value;}) cfg.environmentVariables)
        // (lib.optionalAttrs (cfg.journalFile != null) {
          ZED_BEANCOUNT_JOURNAL.value = toString cfg.journalFile;
        });

      # Add language servers and tools to PATH
      pathAdd = languageServers;

      # No additional flags needed for basic operation
      prependFlags = [];
      appendFlags = [];
    };

    # Create shell aliases for the wrapped version
    # programs.bash.shellAliases.zed = "zed-advanced";
    # programs.zsh.shellAliases.zed = "zed-advanced";
    # programs.fish.shellAliases.zed = "zed-advanced";
  };
}

