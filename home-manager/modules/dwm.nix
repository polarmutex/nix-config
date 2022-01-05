{ pkgs, config, lib, overlays, ... }:
{

  imports = [ ];

  home.packages = with pkgs; [
    my.dwm
  ];

  xsession = {
    enable = true;
    windowManager = {
      command = "${pkgs.my.dwm}/bin/dwm";
    };
    initExtra = ''
      feh --bg-fill --random ~/.config/wallpapers/* &
      xrdb ~/.Xresources
    '';
  };

}
