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
          sha256 = "sha256:156hx301kyyzwlrld17iabyx190l0p2g8f15bw26ya8jqacp1v61";
        }
      )
    ];
  };
}
