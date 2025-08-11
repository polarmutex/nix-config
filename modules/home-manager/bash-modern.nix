{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.bash-modern;
  
  # Smart profile detection based on system characteristics
  autoDetectProfile = 
    if config.programs.starship.enable or false then "full"
    else if config.services.gpg-agent.enable or false then "balanced" 
    else "minimal";

  # Performance budgets (milliseconds)
  performanceProfiles = {
    minimal = { budget = 5; features = [ "core" ]; };
    balanced = { budget = 15; features = [ "core" "interactive" "modern-tools" ]; };
    full = { budget = 30; features = [ "core" "interactive" "modern-tools" "plugins" ]; };
  };

  currentProfile = if cfg.profile == "auto" then autoDetectProfile else cfg.profile;
  
  # Feature availability matrix
  featureEnabled = feature: 
    elem feature performanceProfiles.${currentProfile}.features;

  # Generate shell aliases based on configuration
  generateAliases = 
    # Modern file operations
    (optionalAttrs (cfg.modernTools.fileOperations.ls == "eza") {
      ls = "eza --group-directories-first --icons";
      ll = "eza -lbGF --git --group-directories-first --icons";
      la = "eza -labGF --git --group-directories-first --icons";
      tree = "eza --tree";
    }) //
    (optionalAttrs (cfg.modernTools.fileOperations.cat == "bat") {
      cat = "bat --style=auto";
      less = "bat --style=auto --paging=always";
    }) //
    (optionalAttrs (cfg.modernTools.fileOperations.grep == "ripgrep") {
      grep = "rg";
      rgrep = "rg";
    }) //
    
    # Git shortcuts (if enabled)
    (optionalAttrs cfg.integration.git.shortcuts {
      ga = "git add";
      gc = "git commit";
      gca = "git commit --amend";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log --oneline --graph";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gb = "git branch";
    }) //
    
    # Development shortcuts
    (optionalAttrs cfg.integration.development.docker {
      dk = "docker";
      dkc = "docker-compose";
      dkps = "docker ps";
      dki = "docker images";
      dkl = "docker logs";
    }) //
    (optionalAttrs cfg.integration.development.kubernetes {
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kgn = "kubectl get nodes";
    });

  # Generate package list based on configuration
  generatePackages = with pkgs; [
    bash-completion
  ] 
  ++ optional (cfg.prompt.engine == "starship") starship
  ++ optional (cfg.modernTools.fileOperations.ls == "eza") eza
  ++ optional (cfg.modernTools.fileOperations.ls == "lsd") lsd
  ++ optional (cfg.modernTools.fileOperations.cat == "bat") bat
  ++ optional (cfg.modernTools.fileOperations.grep == "ripgrep") ripgrep
  ++ optional (cfg.modernTools.navigation.smartCd == "zoxide") zoxide
  ++ optional (cfg.modernTools.navigation.fuzzyFinder == "fzf") fzf
  ++ optional (cfg.modernTools.navigation.fuzzyFinder == "skim") skim
  ++ optional cfg.integration.direnv direnv
  ++ optional cfg.integration.git.delta delta
  ++ optional cfg.integration.development.nodejs nodejs
  ++ optional cfg.integration.development.docker docker-compose
  ++ optional cfg.features.autosuggestions.enable (
    if cfg.features.autosuggestions.source == "atuin" then atuin
    else if cfg.features.autosuggestions.source == "mcfly" then mcfly
    else null
  );

in {
  options.programs.bash-modern = {
    enable = mkEnableOption "Modern Bash terminal with Fish/Zsh-like features";

    profile = mkOption {
      type = types.enum [ "minimal" "balanced" "full" "auto" ];
      default = "auto";
      description = ''
        Performance profile for feature activation.
        'auto' detects optimal profile based on system capabilities.
        
        - minimal: Essential features only, <5ms startup
        - balanced: Enhanced features, <15ms startup  
        - full: All features enabled, <30ms startup
      '';
    };

    features = mkOption {
      type = types.submodule {
        options = {
          autosuggestions = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "Fish-style autosuggestions";
                source = mkOption {
                  type = types.enum [ "history" "atuin" "mcfly" ];
                  default = "history";
                  description = "Source for autosuggestions";
                };
                style = mkOption {
                  type = types.submodule {
                    options = {
                      color = mkOption {
                        type = types.str;
                        default = "8"; # Dark gray
                        description = "ANSI color code for suggestions";
                      };
                      maxLength = mkOption {
                        type = types.ints.positive;
                        default = 80;
                        description = "Maximum suggestion length";
                      };
                    };
                  };
                  default = {};
                };
              };
            };
            default = {};
          };

          syntaxHighlighting = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "Real-time syntax highlighting";
                engine = mkOption {
                  type = types.enum [ "builtin" "external" ];
                  default = "builtin";
                  description = "Highlighting engine to use";
                };
                themes = mkOption {
                  type = types.attrsOf types.str;
                  default = {
                    command = "32"; # Green
                    invalid = "31"; # Red
                    string = "33";  # Yellow
                    variable = "34"; # Blue
                    comment = "37";  # Gray
                  };
                  description = "Color theme for syntax elements";
                };
              };
            };
            default = {};
          };

          smartCompletion = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "Enhanced tab completion";
                fuzzyMatch = mkEnableOption "Fuzzy matching in completions";
                preview = mkEnableOption "Preview pane for file completions";
                caseSensitive = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Case-sensitive completion matching";
                };
              };
            };
            default = {};
          };
        };
      };
      default = {};
    };

    modernTools = mkOption {
      type = types.submodule {
        options = {
          fileOperations = mkOption {
            type = types.submodule {
              options = {
                ls = mkOption {
                  type = types.enum [ "eza" "lsd" "disabled" ];
                  default = "eza";
                  description = "Modern ls replacement";
                };
                cat = mkOption {
                  type = types.enum [ "bat" "glow" "disabled" ];
                  default = "bat";
                  description = "Enhanced cat command";
                };
                grep = mkOption {
                  type = types.enum [ "ripgrep" "ugrep" "disabled" ];
                  default = "ripgrep";
                  description = "Fast grep alternative";
                };
              };
            };
            default = {};
          };

          navigation = mkOption {
            type = types.submodule {
              options = {
                smartCd = mkOption {
                  type = types.enum [ "zoxide" "autojump" "disabled" ];
                  default = "zoxide";
                  description = "Intelligent directory jumping";
                };
                fuzzyFinder = mkOption {
                  type = types.enum [ "fzf" "skim" "disabled" ];
                  default = "fzf";
                  description = "Fuzzy finder integration";
                };
              };
            };
            default = {};
          };
        };
      };
      default = {};
    };

    plugins = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Plugin name";
          };
          source = mkOption {
            type = types.either types.path types.str;
            description = "Plugin source (path or URL)";
          };
          lazy = mkOption {
            type = types.bool;
            default = true;
            description = "Load plugin lazily";
          };
          dependencies = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Plugin dependencies";
          };
          condition = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Condition for loading plugin";
          };
        };
      });
      default = [];
      description = "List of plugins to load";
    };

    performance = mkOption {
      type = types.submodule {
        options = {
          startupBudget = mkOption {
            type = types.ints.positive;
            default = performanceProfiles.${currentProfile}.budget;
            description = "Maximum startup time budget in milliseconds";
          };
          lazyLoad = mkOption {
            type = types.bool;
            default = true;
            description = "Enable lazy loading for heavy features";
          };
          profileStartup = mkOption {
            type = types.bool;
            default = false;
            description = "Profile startup time for optimization";
          };
        };
      };
      default = {};
    };

    prompt = mkOption {
      type = types.submodule {
        options = {
          engine = mkOption {
            type = types.enum [ "starship" "powerlevel10k" "custom" ];
            default = "starship";
            description = "Prompt engine to use";
          };
          theme = mkOption {
            type = types.str;
            default = "default";
            description = "Prompt theme configuration";
          };
          async = mkOption {
            type = types.bool;
            default = true;
            description = "Enable async prompt rendering";
          };
        };
      };
      default = {};
    };

    integration = mkOption {
      type = types.submodule {
        options = {
          direnv = mkEnableOption "Direnv integration for project environments";
          
          git = mkOption {
            type = types.submodule {
              options = {
                enable = mkEnableOption "Enhanced git integration";
                delta = mkEnableOption "Delta integration for git diff";
                shortcuts = mkEnableOption "Common git shortcuts";
              };
            };
            default = {};
          };

          development = mkOption {
            type = types.submodule {
              options = {
                nodejs = mkEnableOption "Node.js development enhancements";
                python = mkEnableOption "Python development enhancements";  
                rust = mkEnableOption "Rust development enhancements";
                docker = mkEnableOption "Docker integration";
                kubernetes = mkEnableOption "Kubernetes integration";
              };
            };
            default = {};
          };
        };
      };
      default = {};
    };

    advanced = mkOption {
      type = types.submodule {
        options = {
          asyncInit = mkOption {
            type = types.bool;
            default = true;
            description = "Enable async initialization for heavy features";
          };
          
          memoryLimit = mkOption {
            type = types.ints.positive;
            default = 50; # MB
            description = "Memory limit for shell enhancements";
          };
          
          fallbackMode = mkOption {
            type = types.bool;
            default = true;
            description = "Enable graceful fallback when tools are unavailable";
          };

          experimentalFeatures = mkOption {
            type = types.listOf (types.enum [ 
              "ai-completions" 
              "gesture-navigation" 
              "voice-commands"
              "predictive-typing"
            ]);
            default = [];
            description = "Experimental features to enable";
          };
        };
      };
      default = {};
    };
  };

  config = mkIf cfg.enable {
    # Validation and warnings
    warnings = []
      ++ optional (cfg.performance.startupBudget < 5) 
        "Very low startup budget may cause features to be disabled"
      ++ optional (length cfg.plugins > 20)
        "Large number of plugins may impact performance"
      ++ optional (cfg.features.syntaxHighlighting.enable && !cfg.features.smartCompletion.enable)
        "Syntax highlighting without smart completion may feel incomplete";

    assertions = [
      {
        assertion = cfg.performance.startupBudget > 0;
        message = "Performance startup budget must be positive";
      }
      {
        assertion = cfg.profile != "custom" || cfg.performance.startupBudget <= 100;
        message = "Custom profile startup budget should be reasonable (<100ms)";
      }
    ];

    # Main bash configuration
    programs.bash = {
      enable = true;
      historyControl = [ "ignoreboth" "erasedups" ];
      historySize = 10000;
      historyFileSize = 20000;
      
      shellOptions = [
        "histappend"      # Append to history, don't overwrite
        "checkwinsize"    # Check window size after each command
        "autocd"          # Auto-cd into directories
        "cdspell"         # Auto-correct cd typos
        "dirspell"        # Auto-correct directory spelling
        "globstar"        # Enable ** glob pattern
      ];

      shellAliases = generateAliases;

      initExtra = ''
        # Bash Modern - Performance-optimized shell enhancement
        # Profile: ${currentProfile} | Budget: ${toString cfg.performance.startupBudget}ms
        
        ${optionalString cfg.performance.profileStartup ''
          BASH_MODERN_START=$(date +%s%N)
          echo "[BASH-MODERN] Initialization starting (${currentProfile} profile)..." >&2
        ''}

        # Feature detection and loading
        BASH_MODERN_FEATURES=(${concatStringsSep " " (performanceProfiles.${currentProfile}.features)})
        BASH_MODERN_PROFILE="${currentProfile}"
        
        # Performance tracking
        PERFORMANCE_BUDGET=${toString cfg.performance.startupBudget}
        CURRENT_TIME=0

        # Time tracking function for performance monitoring
        track_time() {
          local label="$1"
          shift
          local start=$(date +%s%N)
          "$@"
          local end=$(date +%s%N)
          local diff=$((end - start))
          CURRENT_TIME=$((CURRENT_TIME + diff / 1000000))
          
          ${optionalString cfg.performance.profileStartup ''
            echo "[PROFILE] $label took $((diff / 1000000))ms (total: ''${CURRENT_TIME}ms)" >&2
          ''}
          
          # Check if we're exceeding budget
          if [[ $CURRENT_TIME -gt $PERFORMANCE_BUDGET ]]; then
            echo "[WARNING] Startup budget exceeded (''${CURRENT_TIME}ms > ''${PERFORMANCE_BUDGET}ms)" >&2
            return 1
          fi
          return 0
        }

        # Load bash modern core
        if [[ -f ~/.config/bash-modern/core.sh ]]; then
          track_time "core" source ~/.config/bash-modern/core.sh
        fi

        # Interactive features (conditional loading)
        ${optionalString (featureEnabled "interactive") ''
          # Autosuggestions
          ${optionalString cfg.features.autosuggestions.enable ''
            if [[ -f ~/.config/bash-modern/autosuggestions.sh ]] && track_time "autosuggestions" source ~/.config/bash-modern/autosuggestions.sh; then
              BASH_MODERN_AUTOSUGGESTIONS=1
            fi
          ''}

          # Syntax highlighting
          ${optionalString cfg.features.syntaxHighlighting.enable ''
            if [[ -f ~/.config/bash-modern/syntax-highlighting.sh ]] && track_time "syntax-highlighting" source ~/.config/bash-modern/syntax-highlighting.sh; then
              BASH_MODERN_SYNTAX_HIGHLIGHTING=1
            fi
          ''}

          # Smart completion
          ${optionalString cfg.features.smartCompletion.enable ''
            if [[ -f ~/.config/bash-modern/smart-completion.sh ]] && track_time "smart-completion" source ~/.config/bash-modern/smart-completion.sh; then
              BASH_MODERN_SMART_COMPLETION=1
            fi
          ''}
        ''}

        # Modern tools integration (conditional loading)
        ${optionalString (featureEnabled "modern-tools") ''
          ${optionalString (cfg.modernTools.navigation.smartCd == "zoxide") ''
            if command -v zoxide > /dev/null; then
              if track_time "zoxide" eval "$(zoxide init bash)"; then
                alias cd='z'
              fi
            fi
          ''}

          ${optionalString (cfg.modernTools.navigation.fuzzyFinder == "fzf") ''
            if command -v fzf > /dev/null; then
              if track_time "fzf" eval "$(fzf --bash)"; then
                export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
                ${optionalString cfg.features.smartCompletion.preview ''
                  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {}'"
                ''}
              fi
            fi
          ''}
        ''}

        # Integration modules
        ${optionalString cfg.integration.direnv ''
          if command -v direnv > /dev/null; then
            track_time "direnv" eval "$(direnv hook bash)"
          fi
        ''}

        ${optionalString cfg.integration.git.enable ''
          ${optionalString cfg.integration.git.delta ''
            if command -v delta > /dev/null; then
              export GIT_PAGER="delta"
            fi
          ''}
        ''}

        # Plugin system (conditional loading)
        ${optionalString (featureEnabled "plugins") ''
          if [[ -f ~/.config/bash-modern/plugin-loader.sh ]]; then
            track_time "plugins" source ~/.config/bash-modern/plugin-loader.sh
          fi
        ''}

        # Prompt initialization
        ${if cfg.prompt.engine == "starship" then ''
          if command -v starship > /dev/null; then
            ${if cfg.prompt.async then ''
              # Async starship initialization
              {
                eval "$(starship init bash)"
              } &
            '' else ''
              track_time "starship" eval "$(starship init bash)"
            ''}
          fi
        '' else ''
          # Fallback prompt with git branch info
          __git_ps1_branch() {
            local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
            [[ -n "$branch" ]] && echo " ($branch)"
          }
          PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(__git_ps1_branch)\[\033[00m\]\$ '
        ''}

        # Final performance report
        ${optionalString cfg.performance.profileStartup ''
          BASH_MODERN_END=$(date +%s%N)
          TOTAL_TIME=$(((BASH_MODERN_END - BASH_MODERN_START) / 1000000))
          echo "[BASH-MODERN] Loaded in ''${TOTAL_TIME}ms (budget: ${toString cfg.performance.startupBudget}ms)" >&2
          echo "[PROFILE] Budget utilization: $((CURRENT_TIME * 100 / PERFORMANCE_BUDGET))%" >&2
        ''}
      '';
    };

    # Package management
    home.packages = generatePackages;

    # XDG integration
    xdg.configFile."shell".source = lib.getExe pkgs.bash;
  };
}