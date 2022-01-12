{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.services.dwm-status;
in
{
  ###### interface
  options = {

    polar.services.dwm-status = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable dwm-status";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.dwm-status = {
      enable = true;

      package = pkgs.dwm-status;

      order = [ "cpu_load" "battery" "time" ];

      extraConfig = lib.mkMerge [
        {
          separator = "    ";
        }

        {
          audio = {
            mute = "ﱝ";
            template = "{ICO} {VOL}%";
            icons = [ "奄" "奔" "墳" ];
          };
        }

        {
          backlight = {
            template = "{ICO} {BL}%";
            icons = [ "" "" "" ];
          };

          battery = {
            charging = "";
            discharging = "";
            no_battery = "";
            icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
          };
        }
      ];
    };
  };
}
