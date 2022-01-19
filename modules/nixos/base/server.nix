{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.polar.base.server;
in

{

  ###### interface

  options = {

    polar.base.server = {
      enable = mkEnableOption "basic server config";

      ipv6Address = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "IPv6 address.";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    polar.services.openssh.enable = true;

    #networking = mkIf (cfg.ipv6Address != null) {
    #  defaultGateway6 = {
    #    address = "fe80::1";
    #    interface = "eth0";
    #  };

    #  interfaces.eth0.ipv6.addresses = [
    #    {
    #      address = cfg.ipv6Address;
    #      prefixLength = 64;
    #    }
    #  ];
    #};

    services.journald.extraConfig = ''
      SystemMaxUse=2G
    '';

  };

}
