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
      rofi
    ];

    xsession = {
      enable = true;
      windowManager = {
        #command = "${pkgs.dwm}/bin/dwm";
        command = "${pkgs.awesome-git}/bin/awesome";
      };
      initExtra = ''
        feh --bg-fill --random ~/.config/wallpapers/* &
        xrdb ~/.Xresources
      '';
    };
  };
}
