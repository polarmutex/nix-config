{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.fathom;
  inherit (config.networking) domain;
in
{

  options.polar.services.fathom = {
    enable = mkEnableOption "fathom stats";
  };

  config = mkIf cfg.enable {

    services.nginx = {
      enable = true;

      virtualHosts = {

        # The Lounge IRC
        "stats.${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9000";
          };
        };
      };
    };

    systemd.services.fathom = {
      description = "Fathom Server";
      requires = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "polar";
        Restart = "on-failure";
        RestartSec = 3;
        WorkingDirectory = "/var/lib/fathom";
        ExecStart = "${pkgs.my.fathom}/bin/fathom --config=/etc/fathom.env server";
      };
    };

    environment.systemPackages = with pkgs; [ my.fathom ];

    environment.etc = {
      # Creates /etc/nanorc
      "fathom.env" = {
        source = "/var/src/machine-config/.secrets/fathom/fathom.env";
        # The UNIX file mode bits
        mode = "0775";
      };
    };
  };

}
