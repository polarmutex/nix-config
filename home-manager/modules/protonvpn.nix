{ lib, pkgs, config, ... }:
with lib;
{
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
}
