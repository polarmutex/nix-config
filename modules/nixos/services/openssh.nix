{ config, lib, pkgs, rootPath, ... }:

with lib;

let
  cfg = config.custom.services.openssh;
in

{

  ###### interface

  options = {

    custom.services.openssh = {
      enable = mkEnableOption "openssh";

      rootLogin = mkEnableOption "root login via pubkey";

      forwardX11 = mkEnableOption "x11 forwarding";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.openssh = {
      inherit (cfg) forwardX11;
      enable = true;
      #openFirewall = true;
      permitRootLogin = "yes"; #mkIf (!cfg.rootLogin) "no";
      passwordAuthentication = true; #TODOfalse;
      #extraConfig = "MaxAuthTries 3";
    };

    users.users = {
      root.openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/polarmutex.keys";
          sha256 = "sha256:01vg72kgaw8scgmfif1sm9wnzq3iis834gn8axhpwl2czxcfysl9";
        })
      ];
      polar.openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/polarmutex.keys";
          sha256 = "sha256:01vg72kgaw8scgmfif1sm9wnzq3iis834gn8axhpwl2czxcfysl9";
        })
      ];
    };

  };

}
