{ self, ... }: {
  flake.nixosModules.obsidian-xvfb-service = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.obsidian-xvfb;
    w = toString cfg.width;
    h = toString cfg.height;

    enableCliScript = pkgs.writeShellScript "obsidian-enable-cli" ''
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
  in {
    options.services.obsidian-xvfb = {
      enable = lib.mkEnableOption "headless Obsidian on a virtual Xvfb display";

      user = lib.mkOption {
        type = lib.types.str;
        default = "polar";
        description = "User to run Obsidian as (must own the vault and ~/.config/obsidian).";
      };

      obsidianPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.obsidian-polar;
        description = "Obsidian package to use.";
      };

      vaultPath = lib.mkOption {
        type = lib.types.str;
        description = "Absolute path to the Obsidian vault (used as WorkingDirectory).";
      };

      display = lib.mkOption {
        type = lib.types.str;
        default = ":99";
        description = "X display number for Xvfb.";
      };

      width = lib.mkOption {
        type = lib.types.int;
        default = 2752;
      };

      height = lib.mkOption {
        type = lib.types.int;
        default = 2014;
      };

      enableVnc = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Run x11vnc on the Xvfb display (localhost-only, no password).";
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services.xvfb = {
        description = "Xvfb virtual framebuffer ${cfg.display}";
        wantedBy = ["multi-user.target"];
        after = ["network-online.target"];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          ExecStart = "${pkgs.xorg.xorgserver}/bin/Xvfb ${cfg.display} -screen 0 ${w}x${h}x24 -ac";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      systemd.services.obsidian-xvfb = {
        description = "Obsidian (headless via Xvfb ${cfg.display})";
        wantedBy = ["multi-user.target"];
        after = ["xvfb.service"];
        requires = ["xvfb.service"];
        environment = {
          DISPLAY = cfg.display;
          XDG_RUNTIME_DIR = "/run/user/${toString (config.users.users.${cfg.user}.uid or 1000)}";
        };
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          WorkingDirectory = cfg.vaultPath;
          ExecStartPre = enableCliScript;
          ExecStart = "${cfg.obsidianPackage}/bin/obsidian --no-sandbox";
          Restart = "on-failure";
          RestartSec = 10;
        };
      };

      systemd.services.x11vnc = lib.mkIf cfg.enableVnc {
        description = "x11vnc on Xvfb ${cfg.display}";
        wantedBy = ["multi-user.target"];
        after = ["xvfb.service"];
        requires = ["xvfb.service"];
        environment.DISPLAY = cfg.display;
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          ExecStartPre = pkgs.writeShellScript "wait-for-xvfb" ''
            until ${pkgs.xorg.xdpyinfo}/bin/xdpyinfo -display ${cfg.display} >/dev/null 2>&1; do
              sleep 1
            done
          '';
          ExecStart = "${pkgs.x11vnc}/bin/x11vnc -display ${cfg.display} -forever -localhost -nopw";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
