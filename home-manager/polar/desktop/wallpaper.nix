{ pkgs, ... }:
{
  home.file = {
    ".config/wallpapers".source = ../../../wallpapers;
  };

  home.packages = with pkgs; [
    feh
  ];
}
