{ config, lib, pkgs, homeModules, rootPath, ... }:

with lib;
let
  cfg = config.custom.base.general;
in
{

  ###### interface
  options = {

    custom.base.general = {
      enable = mkEnableOption "basic config" // { default = true; };

      hostname = mkOption {
        type = types.enum [ "polarbear" "blackbear" "polarvortex" ];
        description = "Host name.";
      };
    };

  };


  ###### implementation
  config = mkIf cfg.enable {

    boot.cleanTmpDir = true;

    #console.keyMap = "de";

    #custom.system.firewall.enable = true;

    environment = {
      defaultPackages = [ ];
      shellAliases = mkForce { };
    };

    networking = {
      hostName = cfg.hostname;
      usePredictableInterfaceNames = false;
    };

    nix = {
      binaryCaches = [
        "https://cache.nixos.org"
        #"https://gerschtli.cachix.org"
      ];
      binaryCachePublicKeys = mkForce [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        #  "gerschtli.cachix.org-1:dWJ/WiIA3W2tTornS/2agax+OI0yQF8ZA2SFjU56vZ0="
      ];
      trustedUsers = [ "root" "polar" ];

      # TODO  what is difference between this and nixFlakes
      package = pkgs.nix_2_4;

      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };

    system.stateVersion = "21.05";

    time.timeZone = "America/New_York";

    users.users = {
      root.shell = pkgs.zsh;

      polar = {
        # FIXME: move mkIf to ids module
        uid = 1000; #mkIf config.custom.ids.enable config.custom.ids.uids.tobias;
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        shell = pkgs.zsh;
      };
    };

  };

}
