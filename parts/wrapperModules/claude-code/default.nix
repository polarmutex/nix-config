# Base claude-code wrapper. Variants import `config.flake.wrapperModules.claude-code-polar`
# (or call `.wrap { inherit pkgs; ... }` for a one-off package); settings/mcpConfig/agents
# are JSON-typed so lists and attrsets merge across modules.
{
  flake.wrappers.claude-code-polar = {
    pkgs,
    lib,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.claude-code];

    settings = {
      includeCoAuthoredBy = false;
      preferProjectMdOverUserMd = false;

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
        ];

        deny = [
          "Bash(rm -rf /:*)"
          "Bash(sudo:*)"
          "Bash(chmod 777:*)"
          "Bash(curl:*)|Bash(wget:*)"
        ];
      };
    };

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
}
