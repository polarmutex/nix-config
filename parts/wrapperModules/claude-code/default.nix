{
  flake.wrappers.claude-code-polar = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: let
    sources = import ../../../npins;
    cfg = config.polar;
  in {
    imports = [wlib.wrapperModules.claude-code];

    options.polar = {
      strictMcpConfig = lib.mkEnableOption "strict MCP config (only use mcpConfig-defined servers)";

      maxContextTokens = lib.mkOption {
        type = lib.types.int;
        default = 15000;
        description = "Maximum tokens to fit in context window.";
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
        description = "Additional agents to merge with the built-in reviewer/architect/debugger agents.";
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

      extraPluginDirs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional plugin directories beyond the built-in llm-wiki and obsidian-skills.";
      };

      extraPathPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Additional packages to add to PATH.";
      };
    };

    config = {
      package = pkgs.claude-code;

      strictMcpConfig = cfg.strictMcpConfig;

      settings = {
        includeCoAuthoredBy = false;
        preferProjectMdOverUserMd = false;
        # maxTokensToFitInContext = cfg.maxContextTokens;

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
      };

      agents =
        {
          # reviewer = {
          #   description = "Code review specialist focusing on quality, security, and best practices";
          #   model = "sonnet";
          #   prompt = ''
          #     You are a senior code reviewer. Analyze code changes for:
          #     - Security vulnerabilities (OWASP Top 10)
          #     - Performance issues and complexity
          #     - Code style and maintainability
          #     - Test coverage gaps
          #     - Documentation completeness
          #
          #     Provide actionable feedback with specific line references.
          #     Prioritize issues by severity: critical > major > minor > suggestion.
          #   '';
          # };

          # architect = {
          #   description = "System design and architecture planning assistant";
          #   model = "sonnet";
          #   prompt = ''
          #     You are a software architect. Help with:
          #     - System design and component architecture
          #     - API design and data modeling
          #     - Technology selection and trade-offs
          #     - Scalability and performance planning
          #     - Migration and refactoring strategies
          #
          #     Always consider maintainability, testability, and operational concerns.
          #     Provide diagrams in mermaid format when helpful.
          #   '';
          # };

          # debugger = {
          #   description = "Systematic debugging and root cause analysis";
          #   model = "sonnet";
          #   prompt = ''
          #     You are a debugging specialist. Approach problems systematically:
          #     1. Reproduce and isolate the issue
          #     2. Form hypotheses based on symptoms
          #     3. Gather evidence through targeted investigation
          #     4. Identify root cause, not just symptoms
          #     5. Propose fix with minimal blast radius
          #
          #     Always explain your reasoning and verify fixes don't introduce regressions.
          #   '';
          # };
        }
        // cfg.extraAgents;

      mcpConfig = cfg.extraMcpServers;

      pluginDirs =
        [
          "${sources.llm-wiki}/claude-plugin"
          "${sources.obsidian-skills}"
        ]
        ++ cfg.extraPluginDirs;

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
  };
}
