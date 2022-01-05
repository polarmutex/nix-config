{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.defaults.networking;
in
{

  options.polar.defaults.networking = {
    enable = mkEnableOption "Network defaults";
  };

  config = mkIf cfg.enable {

    networking = {

      # Define the DNS servers
      #nameservers = [ "192.168.1.1" ];

      # Enables wireless support via wpa_supplicant.
      # networking.wireless.enable = true;

      # Enable networkmanager
      networkmanager.enable = true;

      # Additional hosts to put in /etc/hosts
      extraHosts = ''
      '';
    };
  };
}
