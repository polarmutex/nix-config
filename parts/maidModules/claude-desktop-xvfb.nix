{
  flake.maidModules.claude-desktop-xvfb = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.claude-desktop-xvfb = {
      claudeDesktopPackage = lib.mkOption {
        type = lib.types.package;
      };
      display = lib.mkOption {
        type = lib.types.str;
        default = ":100";
      };
      width = lib.mkOption {
        type = lib.types.int;
        default = 2752;
      };
      height = lib.mkOption {
        type = lib.types.int;
        default = 2014;
      };
    };

    config = let
      cfg = config.claude-desktop-xvfb;
      w = toString cfg.width;
      h = toString cfg.height;
    in {
      systemd.services.claude-desktop-display = {
        description = "Xvfb virtual framebuffer ${cfg.display} for Claude Desktop";
        after = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.xorg.xorgserver}/bin/Xvfb ${cfg.display} -screen 0 ${w}x${h}x24 -ac";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      systemd.services.claude-desktop-xvfb = {
        description = "Claude Desktop (headless via Xvfb)";
        after = ["claude-desktop-display.service"];
        requires = ["claude-desktop-display.service"];
        environment.DISPLAY = cfg.display;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.claudeDesktopPackage}/bin/claude-desktop --no-sandbox";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };
    };
  };
}
