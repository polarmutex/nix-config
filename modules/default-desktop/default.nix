{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.polar.desktop;
in
{

  imports = [ ../../users/polar.nix ];

  options.polar.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";

    homeConfig = mkOption {
      type = types.attrs;
      default = null;
      example = "{}";
      description =
        "Main users account home-manager configuration for the host";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "20.03";
      example = "21.09";
      description = "NixOS state-Version";
    };

    hostname = mkOption {
      type = types.str;
      default = null;
      example = "deepblue";
      description = "hostname to identify the instance";
    };

  };

  config = mkIf cfg.enable {

    home-manager.users.polar = cfg.homeConfig;

    polar = {
      defaults = {
        bluetooth.enable = true;
        environment.enable = true;
        fonts.enable = true;
        locale.enable = true;
        networking.enable = true;
        nix.enable = true;
        sound.enable = true;
        zsh.enable = true;
        yubikey.enable = true;
      };

      virtualisation = {
        docker.enable = true;
      };

      services = {
        xserver.enable = true;
        openssh.enable = true;
      };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      zsh
      lm_sensors
      arandr
      git
      git-crypt
      gh
      gnumake
      gcc
      gnutar
      coreutils
      binutils
      pciutils
      go
      killall
      nodejs
      python
      ripgrep
      wget
      time
      curl
      unzip
      htop
      tmux
      nodejs
      nodePackages.pnpm
      neovim
    ];

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };

    # Define the hostname
    networking.hostName = cfg.hostname;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = cfg.stateVersion; # Did you read the comment?
  };
}
