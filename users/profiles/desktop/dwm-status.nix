{ pkgs, config, lib, ... }:
{
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
}
