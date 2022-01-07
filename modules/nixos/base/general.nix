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

    environment = {
      systemPackages = with pkgs; [
        binutils
        coreutils
        curl
        direnv
        dnsutils
        fd
        gh
        git
        git-crypt
        gnumake
        gnupg
        htop
        moreutils
        neovim
        nix-index
        nmap
        ripgrep
        rsync
        tmux
        wget
        whois
        usbutils
        utillinux
      ];
    };

    networking = {
      hostName = cfg.hostname;
      usePredictableInterfaceNames = false;
    };

    nix = {
      autoOptimiseStore = true;
      binaryCaches = [
        "https://cache.nixos.org"
      ];
      binaryCachePublicKeys = mkForce [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      gc = {
        automatic = true;
        dates = "hourly";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };

      daemonCPUSchedPolicy = lib.mkDefault "idle";
      daemonIOSchedPriority = lib.mkDefault 7;

      trustedUsers = [ "root" "polar" ];

      # TODO  what is difference between this and nixFlakes
      package = pkgs.nix_2_4;

      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    security = {
      #protectKernelImage = lib.mkDefault true;
      # TODO find a way to disable this
      sudo.enable = true;
      doas = {
        enable = true;
        wheelNeedsPassword = false;
        extraRules = [
          {
            users = [ "polar" ];
            noPass = true;
            cmd = "nix-collect-garbage";
            runAs = "root";
          }
        ];
      };
    };

    programs.zsh = {
      enable = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };

    system.stateVersion = "21.05";

    time.timeZone = "America/New_York";

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    users.users = {
      root.shell = pkgs.zsh;

      polar = {
        uid = 1000;
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        shell = pkgs.zsh;
      };
    };

  };

}
