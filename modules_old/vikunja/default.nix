{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.vikunja;
  inherit (config.networking) domain;
  port = 5001;
in
{

  options.polar.services.vikunja = {

    enable = mkEnableOption "vikunja service";

  };

  config = mkIf cfg.enable {

    #users.users.vikunja = {
    #  description = "vikunja Service";
    #  useDefaultShell = true;
    #  group = "vikunja";
    #  isSystemUser = true;
    #};
    #users.groups.vikunja = { };

    services.vikunja = {
      enable = true;
      database = {
        type = "postgres";
        user = "vikunja-api";
        database = "vikunja-api";
        host = "/run/postgresql";
      };
      frontendScheme = "https";
      frontendHostname = "todo.${domain}";
      settings = {
        service = {
          enableregistration = false;
        };
      };
    };
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "vikunja-api" ];
      ensureUsers = [
        {
          name = "vikunja-api";
          ensurePermissions = { "DATABASE \"vikunja-api\"" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.nginx = {
      virtualHosts = {
        "todo.${domain}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

  };
}
