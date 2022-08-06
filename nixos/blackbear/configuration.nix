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

  system.stateVersion = "21.05";

  networking.hostId = "60a00472";
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

  users.users.root.initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";
  users.users.polar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    shell = pkgs.zsh;
  };

  #programs._1password-gui.polkitPolicyOwners = [ "polar" ];

  # services
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    #trim.enable = true;
  };

  nix.settings.trusted-users = [ "root" "@wheel" ];
}
