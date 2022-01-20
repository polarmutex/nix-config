{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.dwm;
in
{
  ###### interface
  options = {

    polar.dwm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable dwm xsession";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dwm
      st
      dmenu
    ];

    xsession = {
      enable = true;
      windowManager = {
        command = "${pkgs.dwm}/bin/dwm";
      };
      initExtra = ''
        feh --bg-fill --random ~/.config/wallpapers/* &
        xrdb ~/.Xresources
      '';
    };
  };
}
