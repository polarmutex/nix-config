{ pkgs, config, lib, ... }:
{
  home.packages = with pkgs;[
    virt-manager
    pavucontrol
    youtube-dl
    element-desktop
    ytfzf
  ];
}
