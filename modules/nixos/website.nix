{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    filterAttrs
    getExe
    hasPrefix
    hasSuffix
    isString
    literalExpression
    maintainers
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    types
    ;

  cfg = config.services.polarmutex-website;
in {
  options.services.polarmutex-website = {
    enable = mkEnableOption "polarmutex-website";

    package = mkPackageOption pkgs "polarmutex-website" {};

    settings = mkOption {
      description = ''
        Additional configuration (environment variables) for my website
      '';
    };

    options = {
      PORT = mkOption {
        type = types.port;
        default = 3000;
        example = 3010;
        description = ''
          The port to listen on.
        '';
      };
    };

    default = {};

    example = {
    };
  };

  config = mkIf cfg.enable {
    assertions = [
    ];

    systemd.services.polarmutex-website = {
      environment = {PORT = builtins.toString cfg.settings.PORT;};

      description = "polrmutex-website: my website";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        ${getExe cfg.package}
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
        DynamicUser = true;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };

  meta.maintainers = with maintainers; [polarmutex];
}
