{...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.graphical;
in {
  options.profiles.graphical = {
    enable = lib.mkEnableOption "enable graphical";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      exfat
      ntfs3g
      st
      arandr
    ];
  };
}
