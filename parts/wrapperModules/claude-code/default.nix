{
  flake.wrappers.claude-code-polar = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.claude-code];
    config = {
      package = pkgs.claude-code;

      # Application settings for software engineering workflows
      settings = {
        # Include co-author attribution in commits
        includeCoAuthoredBy = true;

        # Prefer project-specific instructions
        preferProjectMdOverUserMd = false;

        # Reasonable context window management
        maxTokensToFitInContext = 15000;

        # Permission patterns for common dev operations
        permissions = {
          allow = [
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

            # Git operations (read-only by default)
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
          ];

          deny = [
            # Dangerous operations
            "Bash(rm -rf /:*)"
            "Bash(sudo:*)"
            "Bash(chmod 777:*)"
            "Bash(curl:*)|Bash(wget:*)" # Prevent arbitrary downloads in pipes
          ];
        };
      };

      # Custom agents for common software engineering tasks
      agents = {
        reviewer = {
          description = "Code review specialist focusing on quality, security, and best practices";
          model = "sonnet";
          prompt = ''
            You are a senior code reviewer. Analyze code changes for:
            - Security vulnerabilities (OWASP Top 10)
            - Performance issues and complexity
            - Code style and maintainability
            - Test coverage gaps
            - Documentation completeness

            Provide actionable feedback with specific line references.
            Prioritize issues by severity: critical > major > minor > suggestion.
          '';
        };

        architect = {
          description = "System design and architecture planning assistant";
          model = "sonnet";
          prompt = ''
            You are a software architect. Help with:
            - System design and component architecture
            - API design and data modeling
            - Technology selection and trade-offs
            - Scalability and performance planning
            - Migration and refactoring strategies

            Always consider maintainability, testability, and operational concerns.
            Provide diagrams in mermaid format when helpful.
          '';
        };

        debugger = {
          description = "Systematic debugging and root cause analysis";
          model = "sonnet";
          prompt = ''
            You are a debugging specialist. Approach problems systematically:
            1. Reproduce and isolate the issue
            2. Form hypotheses based on symptoms
            3. Gather evidence through targeted investigation
            4. Identify root cause, not just symptoms
            5. Propose fix with minimal blast radius

            Always explain your reasoning and verify fixes don't introduce regressions.
          '';
        };
      };

      # Add useful tools to PATH
      prefixVar = [
        [
          "PATH"
          ":"
          (lib.makeBinPath [
            pkgs.ripgrep
            pkgs.fd
            pkgs.jq
            pkgs.gh
            pkgs.git
          ])
        ]
      ];
    };
  };
}
