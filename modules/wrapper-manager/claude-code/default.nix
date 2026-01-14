{
  # config,
  lib,
  pkgs,
  ...
}: let
  jsonFormat = pkgs.formats.json {};

  # Wrapper script for github-mcp-server that reads the token from secrets
  github-mcp-wrapper = pkgs.writeShellScriptBin "github-mcp-server-wrapped" ''
    if [ -f /run/secrets/gh-mcp ]; then
      export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat /run/secrets/gh-mcp)
    fi
    exec ${pkgs.github-mcp-server}/bin/github-mcp-server "$@"
  '';

  mcpServers = {
    context7 = {
      type = "stdio";
      command = "${pkgs.context7-mcp}/bin/context7-mcp";
      args = ["--transport" "stdio"];
    };
    github = {
      type = "stdio";
      command = "${github-mcp-wrapper}/bin/github-mcp-server-wrapped";
      args = ["stdio" "--dynamic-toolsets"];
    };
    nixos = {
      type = "stdio";
      command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
    };
  };
in {
  wrappers.claude-code = {
    basePackage = pkgs.unstable.claude-code;
    extraPackages = [
      pkgs.context7-mcp
      github-mcp-wrapper
      pkgs.mcp-nixos
    ];
    appendFlags = lib.optionals (mcpServers != {}) [
      "--mcp-config"
      "${jsonFormat.generate "claude-code-mcp-config.json" {inherit mcpServers;}}"
    ];
  };
}
