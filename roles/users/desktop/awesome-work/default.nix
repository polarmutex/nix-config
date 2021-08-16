{ pkgs, config, lib, overlays, ... }:
let
  utils = import ../../utils.nix { config = config; };

in
{

  imports = [
    ../shared/st.nix
    ../shared/dmenu.nix
    ../shared/wallpapers.nix
    ../shared/bluetooth.nix
    ../shared/rofi.nix
  ];


  xdg.configFile = utils.link-one "config" "." "awesome";

  xsession = {
    enable = true;
    windowManager= {
        command = "awesome";
    };
    initExtra = ''
      feh --bg-fill --random ~/.config/wallpapers/* &
      xrdb ~/.Xresources
    '';
  };

}
