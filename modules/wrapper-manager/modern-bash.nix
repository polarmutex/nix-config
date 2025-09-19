{
  config,
  lib,
  pkgs,
  inputs',
  ...
}: let
  cfg = config.wrappers.modern-bash;
  modern-bash-pkg = pkgs.modern-bash or (pkgs.callPackage ../../packages/modern-bash.nix {});
in {
  options.wrappers.modern-bash = {
    enable = lib.mkEnableOption "Modern Bash wrapper with nix-maid";

    basePackage = lib.mkOption {
      type = lib.types.package;
      default = modern-bash-pkg;
      description = "Base modern-bash package to wrap";
    };

    wrapperName = lib.mkOption {
      type = lib.types.str;
      default = "modern-bash";
      description = "Name of the wrapper executable";
    };

    enableDebug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug output for troubleshooting";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to modern-bash";
    };

    environmentVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Environment variables to set in the wrapper";
    };

    preExec = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Commands to run before executing modern-bash";
    };

    postExec = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Commands to run after modern-bash exits";
    };
  };

  config = lib.mkIf cfg.enable {
    build.packages.modern-bash = inputs'.nix-maid.lib.wrap {
      package = cfg.basePackage;
      name = cfg.wrapperName;
      
      script = ''
        #!/usr/bin/env bash
        set -euo pipefail
        
        ${lib.optionalString cfg.enableDebug ''
          echo "[DEBUG] Modern Bash Wrapper Started"
          echo "[DEBUG] Args: $*"
          echo "[DEBUG] Working Directory: $(pwd)"
          echo "[DEBUG] User: $(whoami)"
        ''}
        
        # Set environment variables
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: value: ''export ${name}="${value}"'') 
          (cfg.environmentVariables // {
            MODERN_BASH_WRAPPED = "1";
            MODERN_BASH_WRAPPER_VERSION = "1.0.0";
          })
        )}
        
        # Pre-execution commands
        ${cfg.preExec}
        
        # Determine execution mode
        if [[ $# -eq 0 ]]; then
          # Interactive mode - start modern bash shell
          ${lib.optionalString cfg.enableDebug ''
            echo "[DEBUG] Starting interactive modern-bash"
          ''}
          exec "${cfg.basePackage}/bin/modern-bash" ${lib.escapeShellArgs cfg.extraArgs}
        elif [[ "$1" == "--setup" ]]; then
          # Setup mode - run setup script
          ${lib.optionalString cfg.enableDebug ''
            echo "[DEBUG] Running setup-modern-bash"
          ''}
          exec "${cfg.basePackage}/bin/setup-modern-bash" "''${@:2}"
        elif [[ "$1" == "--version" ]]; then
          # Version information
          echo "Modern Bash Wrapper v1.0.0"
          echo "Based on: ${cfg.basePackage.name or "modern-bash"}"
          echo "Wrapped with: nix-maid"
          exit 0
        elif [[ "$1" == "--help" ]]; then
          # Help information
          cat << 'EOF'
        Modern Bash - Bash shell with fish-like features
        
        Usage: modern-bash [OPTIONS] [SCRIPT] [ARGS...]
        
        OPTIONS:
          --help     Show this help message
          --version  Show version information
          --setup    Run setup to configure existing bash
          --debug    Enable debug output
        
        FEATURES:
          - Autosuggestions based on command history
          - Syntax highlighting for commands
          - Smart tab completion with fuzzy matching
          - Command abbreviations (g -> git, ga -> git add)
          - Enhanced history management with fzf
          - Improved vi mode with visual indicators
          - Smart directory navigation
        
        EXAMPLES:
          modern-bash              Start interactive shell
          modern-bash --setup      Configure existing ~/.bashrc
          modern-bash script.sh    Run a script with modern bash
        
        Environment Variables:
          MODERN_BASH_AUTOSUGGESTIONS=1    Enable/disable autosuggestions
          MODERN_BASH_SYNTAX_HIGHLIGHTING=1    Enable/disable syntax highlighting
          MODERN_BASH_FUZZY_COMPLETION=1    Enable/disable fuzzy completion
        
        EOF
          exit 0
        else
          # Script execution mode
          ${lib.optionalString cfg.enableDebug ''
            echo "[DEBUG] Executing script: $1"
          ''}
          exec "${cfg.basePackage}/bin/modern-bash" ${lib.escapeShellArgs cfg.extraArgs} "$@"
        fi
        
        # Post-execution commands (only reached if exec fails)
        exit_code=$?
        ${cfg.postExec}
        exit $exit_code
      '';
      
      meta = cfg.basePackage.meta // {
        description = "${cfg.basePackage.meta.description or "Modern Bash"} (nix-maid wrapped)";
        longDescription = ''
          ${cfg.basePackage.meta.longDescription or ""}
          
          This package is wrapped using nix-maid for enhanced integration and deployment.
        '';
      };
    };

    # Add wrapper-specific environment setup
    environment = lib.mkIf (cfg.environmentVariables != {}) {
      sessionVariables = cfg.environmentVariables;
    };
  };
}