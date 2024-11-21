{
  inputs,
  pkgs,
  ...
}: let
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  interval = "10m";
  imageDirectory = "${inputs.wallpapers.packages.${pkgs.system}.polar-wallpapers}/share/wallpapers";
in {
  home.packages = [
    # pkgs.feh
  ];

  # X11
  # services.random-background = {
  #   enable = true;
  #   display = "scale";
  #   interval = "15m";
  #   imageDirectory = "${inputs.wallpapers.packages.${pkgs.system}.polar-wallpapers}/share/wallpapers";
  # };

  # wayland

  systemd.user.services.random-background-wayland = {
    Unit = {
      Description = "Set random desktop background using hyprpaper";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "wayland-change-background" ''
        #!/bin/sh

        WALLPAPER_DIR="${imageDirectory}"

        OLDIFS=$IFS
        IFS=$'\n'
        for wallpaper in $("${package}/bin/hyprctl"  hyprpaper listloaded); do
        	"${package}/bin/hyprctl" hyprpaper unload "$wallpaper"
        done
        IFS=$OLDIFS

        for display in $("${package}/bin/hyprctl" monitors | grep "Monitor" | cut -d " " -f 2); do
        	wallpaper="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
        	"${package}/bin/hyprctl" hyprpaper preload "$wallpaper"
        	"${package}/bin/hyprctl" hyprpaper wallpaper "$display,$wallpaper"
        done
      ''}";
      IOSchedulingClass = "idle";
    };

    Install = {WantedBy = ["graphical-session.target"];};
  };
  systemd.user.timers.random-background-wayland = {
    Unit = {Description = "Set random desktop background using hyprpaper";};

    Timer = {OnUnitActiveSec = interval;};

    Install = {WantedBy = ["timers.target"];};
  };
}
