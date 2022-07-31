{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../modules/core
    ../modules/dev
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/nvidia.nix
    ../modules/hardware/yubikey.nix
    ../modules/graphical
    ../modules/graphical/awesomewm.nix
    ../modules/graphical/trusted.nix
  ];

  system.stateVersion = "2021.05";

  networking.hostId = "e58e2ad4";
  networking.hostName = "blackbear";

  time.timeZone = "US/Eastern";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # ZFS boot settings
  boot.supportedFilesystems = [ "zfs" ];
  #boot.zfs.devNodes = "/dev/";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    coreutils
    gitAndTools.gitFull
    gptfdisk
    neovim
    wget
  ];

  users.users.polar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    shell = pkgs.zsh;
  };
  programs._1password-gui.polkitPolicyOwners = [ "polar" ];

  # services
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    #trim.enable = true;
  };

  nix.settings.trusted-users = [ "root" "@wheel" ];
}
