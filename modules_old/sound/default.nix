{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.defaults.sound;
in
{

  options.polar.defaults.sound = { enable = mkEnableOption "sound defaults"; };
  config = mkIf cfg.enable {

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };
}
