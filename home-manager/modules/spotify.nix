{ pkgs, lib, config, ... }:
{
  home.file = {
    ".config/spotifyd/config".source = ../../../.secrets/spotifyd/spotifyd.conf;
  };


  systemd.user.services.spotifyd = {
    Service = {
      ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --config-path /home/brian/.config/spotifyd/config";
      Restart = "always";
      RestartSec = 6;
    };

    Unit = {
      After = "graphical-session-pre.target";
      Description = "Spotify Daemon";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = with pkgs; [
    spotifyd
    spotify-tui
  ];
}
