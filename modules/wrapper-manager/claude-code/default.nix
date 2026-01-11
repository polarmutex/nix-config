{
  # config,
  lib,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};
  mcpServers = {
    context7 = {command = "context7-mcp";};
    github = {
      type = "stdio";
      command = "github-mcp-server";
      args = ["stdio" "--dynamic-toolsets"];
      env = {
        # GITHUB_PERSONAL_ACCESS_TOKEN = config.sops.secrets.gh-mcp;
        GITHUB_PERSONAL_ACCESS_TOKEN = "$(cat /run/secrets/gh-mcp)";
      };
    };
    nixos = {command = "mcp-nixos";};
  };
in {
  wrappers.claude-code = {
    basePackage = pkgs.unstable.claude-code;
    appendFlags = lib.optionals (mcpServers != {}) [
      "--mcp-config"
      "${jsonFormat.generate "claude-code-mcp-config.json" {inherit mcpServers;}}"
    ];
  };
}
