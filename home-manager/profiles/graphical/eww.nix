{ inputs
, lib
, config
, pkgs
, ...
}:
let
in
{

  # eww package
  home.packages = with pkgs; [
    eww
    pamixer
    brightnessctl
  ];

  # configuration
  home.file.".config/eww/eww.scss".source = ./eww.scss;
  home.file.".config/eww/eww.yuck".source = ./eww.yuck;

  # scripts
  home.file.".config/eww/scripts/getram" = {
    text = ''
      #!/bin/sh
      printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
    '';
    executable = true;
  };

  home.file.".config/eww/scripts/getvol" = {
    text = ''
      #!/bin/sh
      amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%' | head -1
    '';
    executable = true;
  };
  #home.file.".config/eww/scripts/battery.sh" = {
  #  source = ./scripts/battery.sh;
  #  executable = true;
  #};

  #home.file.".config/eww/scripts/wifi.sh" = {
  #  source = ./scripts/wifi.sh;
  #  executable = true;
  #};

  #home.file.".config/eww/scripts/brightness.sh" = {
  #  source = ./scripts/brightness.sh;
  #  executable = true;
  #};

  #home.file.".config/eww/scripts/workspaces.sh" = {
  #  source = ./scripts/workspaces.sh;
  #  executable = true;
  #};

  #home.file.".config/eww/scripts/workspaces.lua" = {
  #  source = ./scripts/workspaces.lua;
  #  executable = true;
  #};
}
