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
        default = 2014;
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
          # Inject "cli": true into the global Obsidian config before launch.
          # Without this the CLI falls through to launching a new instance instead
          # of routing commands to the running one (obsidianless discovery).
          ExecStartPre = pkgs.writeShellScript "obsidian-enable-cli" ''
            CONFIG_DIR="$HOME/.config/obsidian"
            CONFIG_FILE="$CONFIG_DIR/obsidian.json"
            mkdir -p "$CONFIG_DIR"
            if [ -f "$CONFIG_FILE" ]; then
              ${pkgs.jq}/bin/jq '. + {"cli": true}' "$CONFIG_FILE" \
                > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
            else
              printf '{"cli":true}\n' > "$CONFIG_FILE"
            fi
          '';
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
