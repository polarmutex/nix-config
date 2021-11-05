{ pkgs, config, lib, ... }:
{
  home.packages = with pkgs; [
    picom
  ];

  services.picom = {
    enable = true;
    shadow = true;
    backend = "glx";
    activeOpacity = "1.0";
  };
}
