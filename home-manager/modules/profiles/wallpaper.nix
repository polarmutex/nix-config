{wallpapers, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.wallpapers;
in {
  options.profiles.wallpapers = {
    enable = lib.mkEnableOption "The wallpapers profile";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      feh
    ];

    services.random-background = {
      enable = true;
      display = "scale";
      interval = "15m";
      imageDirectory = "${wallpapers.packages.${pkgs.system}.polar-wallpapers}/share/wallpapers";
    };
  };
}
