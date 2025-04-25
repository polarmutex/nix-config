{
  self,
  pkgs,
  lib,
  ...
}: {
  programs = {
    nushell = {
      enable = true;
      # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
      # configFile.source = ./.../config.nu;
      # for editing directly to config.nu
      extraConfig = ''
        let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
            show_banner: false,
            completions: {
                case_sensitive: false,
                quick: true,
                partial: true,
                algorithm: "fuzzy",
                external: {
                    enable: true
                    max_results: 100
                    completer: $carapace_completer
                }
            },
            hooks: {
                pre_prompt: [{ ||
                if (which direnv | is-empty) {
                    return
                }

                direnv export json | from json | default {} | load-env
                if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
                    $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
                }
                }]
            }
        }
      '';
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
  xdg.configFile."shell".source = lib.getExe pkgs.nushell;
}
