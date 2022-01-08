{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.polar.services.protonvpn;
in
{
  ###### interface

  options = {

    polar.services.protonvpn = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable protonvpn";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ protonvpn-cli ];
    #systemd.user.services.protonvpn-autoconnect = {
    #  Unit = {
    #    Description = "ProtonVPN-CLI auto-connect";
    #  };
    #  Service = {
    #    Type = "forking";
    #    Environment =
    #      [ "PVPN_WAIT=300" "PVPN_DEBUG=1" "SUDO_USER=polar" ];
    #    ExecStart = "${pkgs.protonvpn-cli}/bin/protonvpn c -f";
    #  };
    #};
  };
}
