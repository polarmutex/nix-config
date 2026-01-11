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
      args = ["stdio"];
      env = {
        # GITHUB_PERSONAL_ACCESS_TOKEN = config.sops.secrets.gh-mcp;
        GITHUB_PERSONAL_ACCESS_TOKEN = "$(cat /run/secrets/gh-mcp)";
      };
    };
    # filesystem = {
    #   type = "stdio";
    #   command = "npx";
    #   args = [
    #     "-y"
    #     "@modelcontextprotocol/server-filesystem"
    #     "/tmp"
    #   ];
    # };
    # database = {
    #   type = "stdio";
    #   command = "npx";
    #   args = [
    #     "-y"
    #     "@bytebase/dbhub"
    #     "--dsn"
    #     "postgresql://user:pass@localhost:5432/db"
    #   ];
    #   env = {
    #     DATABASE_URL = "postgresql://user:pass@localhost:5432/db";
    #   };
    # };
    # customTransport = {
    #   type = "websocket";
    #   url = "wss://example.com/mcp";
    #   customOption = "value";
    #   timeout = 5000;
    # };
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
