{
  flake.wrappers.claude-code-morgen = {pkgs, wlib, ...}: {
    imports = [wlib.wrapperModules.claude-code ./_shared.nix];

    polar = {
      binName = "claude-morgen";
      extraAllowedCommands = [
        "Edit(**)"
        "WebFetch(domain:forecast.weather.gov)"
      ];
      extraDeniedCommands = [
      ];
      extraMcpServers.morgen = {
        command = "${pkgs.morgen-mcp}/bin/morgenmcp";
        type = "stdio";
      };
    };
  };
}
