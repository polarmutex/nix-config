{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.openssh;
in
{

  options.polar.services.openssh = {
    enable = mkEnableOption "OpenSSH server";
  };

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      allowSFTP = false;
      challengeResponseAuthentication = false;
      openFirewall = false;
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };

    users.users.root.openssh.authorizedKeys.keyFiles = [
      (
        builtins.fetchurl {
          url = "https://github.com/polarmutex.keys";
          sha256 = "sha256:0slkpn1r4kmwyj15hznyycgxj6vscjc1k3bdd1jj0prvshcrcl5n";
        }
      )
    ];
  };
}
