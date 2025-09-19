{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.modern-bash;
in {
  options.programs.modern-bash = {
    enable = lib.mkEnableOption "Modern Bash with fish-like features";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.modern-bash;
      description = "The modern-bash package to use";
    };

    enableAutosuggestions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable command autosuggestions";
    };

    enableSyntaxHighlighting = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable syntax highlighting";
    };

    enableFuzzyCompletion = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fuzzy tab completion";
    };

    enableAbbreviations = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable command abbreviations";
    };

    enableViMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable enhanced vi mode";
    };

    customAbbreviations = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "gco" = "git checkout";
        "gst" = "git status";
        "ll" = "ls -la";
      };
      description = "Custom abbreviations to add";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra configuration to add to bashrc";
    };

    shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "grep" = "grep --color=auto";
        "ls" = "ls --color=auto";
      };
      description = "Shell aliases";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package pkgs.fzf ];

    programs.bash = {
      enable = true;
      
      bashrcExtra = lib.concatLines [
        # Load modern bash features
        ''
          # Modern Bash Configuration
          export MODERN_BASH_ENABLED=1
        ''
        
        # Conditional feature loading
        (lib.optionalString cfg.enableAutosuggestions ''
          export MODERN_BASH_AUTOSUGGESTIONS=1
        '')
        
        (lib.optionalString cfg.enableSyntaxHighlighting ''
          export MODERN_BASH_SYNTAX_HIGHLIGHTING=1
        '')
        
        (lib.optionalString cfg.enableFuzzyCompletion ''
          export MODERN_BASH_FUZZY_COMPLETION=1
        '')
        
        (lib.optionalString cfg.enableAbbreviations ''
          export MODERN_BASH_ABBREVIATIONS=1
        '')
        
        (lib.optionalString cfg.enableViMode ''
          export MODERN_BASH_VI_MODE=1
        '')
        
        # Custom abbreviations
        (lib.optionalString (cfg.customAbbreviations != {}) (
          let
            abbreviations = lib.mapAttrsToList 
              (abbr: expansion: ''["${abbr}"]="${expansion}"'')
              cfg.customAbbreviations;
          in ''
            # Custom abbreviations
            declare -A __custom_abbr_map=(
              ${lib.concatStringsSep "\n  " abbreviations}
            )
            
            # Merge with default abbreviations
            for abbr in "''${!__custom_abbr_map[@]}"; do
              __bash_abbr_map["$abbr"]="''${__custom_abbr_map[$abbr]}"
            done
          ''
        ))
        
        # Load the main modern bash configuration
        ''
          if [[ -f "${cfg.package}/share/modern-bash/bashrc" ]]; then
            source "${cfg.package}/share/modern-bash/bashrc"
          fi
        ''
        
        # Extra user configuration
        cfg.extraConfig
      ];

      # Shell aliases
      shellAliases = cfg.shellAliases // {
        # Default modern bash aliases
        "e" = lib.mkDefault "\${EDITOR:-vim}";
        "cls" = lib.mkDefault "clear";
        "grep" = lib.mkDefault "grep --color=auto";
        "ls" = lib.mkDefault "ls --color=auto";
        "ll" = lib.mkDefault "ls -la";
        "la" = lib.mkDefault "ls -A";
        "l" = lib.mkDefault "ls -CF";
        ".." = lib.mkDefault "cd ..";
        "..." = lib.mkDefault "cd ../..";
        "...." = lib.mkDefault "cd ../../..";
      };
    };

    # Add modern-bash to PATH
    home.sessionPath = [ "${cfg.package}/bin" ];

    # Set environment variables for modern bash features
    home.sessionVariables = {
      MODERN_BASH_PACKAGE = "${cfg.package}";
    } // lib.optionalAttrs cfg.enableAutosuggestions {
      MODERN_BASH_AUTOSUGGESTIONS = "1";
    } // lib.optionalAttrs cfg.enableSyntaxHighlighting {
      MODERN_BASH_SYNTAX_HIGHLIGHTING = "1";
    } // lib.optionalAttrs cfg.enableFuzzyCompletion {
      MODERN_BASH_FUZZY_COMPLETION = "1";
    };

    # Desktop entry for modern bash
    xdg.desktopEntries.modern-bash = lib.mkIf pkgs.stdenv.isLinux {
      name = "Modern Bash";
      comment = "Bash shell with fish-like features";
      icon = "utilities-terminal";
      exec = "${cfg.package}/bin/modern-bash";
      categories = [ "System" "TerminalEmulator" ];
      terminal = true;
    };
  };
}