{config, ...}: {
  flake.wrappers.claude-code-daily-log = {...}: {
    imports = [config.flake.wrapperModules.claude-code-polar];

    binName = "claude-daily-log";
    settings.permissions.allow = [
      "Edit(**)"
      "WebFetch(domain:forecast.weather.gov)"
    ];
    mcpConfig.morgen = {
      type = "http";
      url = "https://mcp.morgen.so/mcp";
    };
  };
}
