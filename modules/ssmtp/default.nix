{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.ssmtp;
  domain = config.networking.domain;
in
{

  options.polar.services.ssmtp = {
    enable = mkEnableOption "ssmtp";
  };

  config = mkIf cfg.enable {

    services.ssmtp = {
      enable = true;

      hostName = "smtp.gmail.com:587";
      domain = "${domain}";
      useTLS = true;
      useSTARTTLS = true;
      root = "bryall@gmail.com";
      authUser = "bryall";
      authPassFile = "/var/src/machine-config/.secrets/ssmtp/credentials";
      setSendmail = true;

    };
  };
}
