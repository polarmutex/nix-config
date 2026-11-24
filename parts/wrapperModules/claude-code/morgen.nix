{config, ...}: {
  flake.wrappers.claude-code-morgen = {pkgs, ...}: {
    imports = [config.flake.wrapperModules.claude-code-polar];

    binName = "claude-morgen";
    settings.permissions.allow = [
      "Edit(**)"
      "WebFetch(domain:forecast.weather.gov)"
    ];
    mcpConfig.morgen = {
      command = "${pkgs.morgen-mcp}/bin/morgenmcp";
      type = "stdio";
    };
  };
}
