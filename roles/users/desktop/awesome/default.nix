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
    ../shared/picom.nix
  ];

  home.packages = with pkgs; [
    awesome
  ];

  xdg.configFile = utils.link-one "config" "." "awesome";

  xsession = {
    enable = true;
    windowManager = {
      command = "${pkgs.awesome}/bin/awesome";
    };
    initExtra = ''
      feh --bg-fill --random ~/.config/wallpapers/* &
      xrdb ~/.Xresources
    '';
  };

}
