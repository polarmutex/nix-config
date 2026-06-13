{
  flake.maidModules.obsidian-xvfb = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.obsidian-xvfb = {
      obsidianPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.obsidian-polar;
      };
      vaultPath = lib.mkOption {
        type = lib.types.str;
        default = "/home/polar/repos/personal/ideaverse";
      };
      display = lib.mkOption {
        type = lib.types.str;
        default = ":99";
      };
      width = lib.mkOption {
        type = lib.types.int;
        default = 2752;
      };
      height = lib.mkOption {
        type = lib.types.int;
        default = 2064;
      };
    };

    config = let
      cfg = config.obsidian-xvfb;
      w = toString cfg.width;
      h = toString cfg.height;
    in {
      systemd.services.xvfb = {
        description = "Xvfb virtual framebuffer ${cfg.display}";
        after = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.xorg.xorgserver}/bin/Xvfb ${cfg.display} -screen 0 ${w}x${h}x24 -ac";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      systemd.services.obsidian-xvfb = {
        description = "Obsidian (headless via Xvfb)";
        after = ["xvfb.service"];
        requires = ["xvfb.service"];
        environment.DISPLAY = cfg.display;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${cfg.obsidianPackage}/bin/obsidian --no-sandbox";
          ExecStartPost = "${pkgs.writeShellScript "obsidian-resize" ''
            sleep 5
            ${pkgs.xdotool}/bin/xdotool search --sync --class obsidian windowsize %@ ${w} ${h} windowmove %@ 0 0
          ''}";
          WorkingDirectory = cfg.vaultPath;
          Restart = "on-failure";
          RestartSec = 10;
        };
      };
    };
  };
}
