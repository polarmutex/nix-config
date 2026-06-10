# Shared polar.* options and base config for all claude-code wrappers
{
  config,
  lib,
  pkgs,
  wlib,
  ...
}: let
  cfg = config.polar;
in {
  options.polar = {
    binName = lib.mkOption {
      type = lib.types.str;
      default = "claude";
      description = "Override bin name of wrapper";
    };

    strictMcpConfig = lib.mkEnableOption "strict MCP config (only use mcpConfig-defined servers)";

    maxContextTokens = lib.mkOption {
      type = lib.types.int;
      default = 15000;
      description = "Maximum tokens to fit in context window.";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Additional claude-code settings";
    };

    extraAllowedCommands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional bash commands to allow beyond the defaults.";
      example = ["Bash(docker:*)" "Bash(kubectl:*)"];
    };

    extraDeniedCommands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional bash commands to deny beyond the defaults.";
    };

    extraAgents = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          description = lib.mkOption {type = lib.types.str;};
          model = lib.mkOption {
            type = lib.types.enum ["sonnet" "opus" "haiku"];
            default = "sonnet";
          };
          prompt = lib.mkOption {type = lib.types.str;};
          tools = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };
        };
      });
      default = {};
      description = "Additional agents to merge with the built-in agents.";
    };

    extraMcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Additional MCP servers to add to mcpConfig.";
      example = {
        nixos = {
          command = "/path/to/mcp-nixos";
          type = "stdio";
        };
      };
    };

    channels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Channels to activate (passed as --channels flags).";
      example = ["plugin:telegram@claude-plugins-official"];
    };

    extraPluginDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional plugin directories beyond the built-in defaults.";
    };

    extraPathPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages to add to PATH.";
    };
  };

  config = {
    package = pkgs.claude-code;
    binName = cfg.binName;

    inherit (cfg) strictMcpConfig;

    settings =
      {
        includeCoAuthoredBy = false;
        preferProjectMdOverUserMd = false;

        permissions = {
          allow =
            [
              # Build and test tools
              "Bash(npm:*)"
              "Bash(pnpm:*)"
              "Bash(yarn:*)"
              "Bash(bun:*)"
              "Bash(cargo:*)"
              "Bash(go:*)"
              "Bash(make:*)"
              "Bash(just:*)"
              "Bash(nix:*)"
              "Bash(nix-build:*)"
              "Bash(nix-shell:*)"

              # Testing frameworks
              "Bash(pytest:*)"
              "Bash(vitest:*)"
              "Bash(jest:*)"
              "Bash(cargo test:*)"
              "Bash(go test:*)"

              # Linting and formatting
              "Bash(eslint:*)"
              "Bash(prettier:*)"
              "Bash(black:*)"
              "Bash(ruff:*)"
              "Bash(rustfmt:*)"
              "Bash(gofmt:*)"
              "Bash(nixfmt:*)"
              "Bash(alejandra:*)"

              # Git operations (read-only)
              "Bash(git status:*)"
              "Bash(git diff:*)"
              "Bash(git log:*)"
              "Bash(git branch:*)"
              "Bash(git show:*)"
              "Bash(git ls-files:*)"

              # Common utilities
              "Bash(ls:*)"
              "Bash(find:*)"
              "Bash(grep:*)"
              "Bash(sort:*)"
              "Bash(head:*)"
              "Bash(xargs:*)"
              "Bash(tree:*)"
              "Bash(wc:*)"
              "Bash(which:*)"
              "Bash(pwd:*)"
              "Bash(env:*)"
            ]
            ++ cfg.extraAllowedCommands;

          deny =
            [
              "Bash(rm -rf /:*)"
              "Bash(sudo:*)"
              "Bash(chmod 777:*)"
              "Bash(curl:*)|Bash(wget:*)"
            ]
            ++ cfg.extraDeniedCommands;
        };
      }
      // cfg.extraSettings;

    agents = {} // cfg.extraAgents;

    mcpConfig = {} // cfg.extraMcpServers;

    pluginDirs = cfg.extraPluginDirs;

    flags."--channels" = lib.mkIf (cfg.channels != []) cfg.channels;

    prefixVar = [
      [
        "PATH"
        ":"
        (lib.makeBinPath (
          [
            pkgs.ripgrep
            pkgs.fd
            pkgs.jq
            pkgs.gh
            pkgs.git
          ]
          ++ cfg.extraPathPackages
        ))
      ]
    ];
  };
}
