{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.polar.defaults.bluetooth;
in
{

  options.polar.defaults.bluetooth = {
    enable = mkEnableOption "default bluetooth configuration";
  };

  config = mkIf cfg.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
