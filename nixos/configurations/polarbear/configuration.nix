{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  networking.hostId = "f98b90a0";
  networking.hostName = "polarbear";

  time.timeZone = "US/Eastern";

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    useDHCP = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    anki-bin
    ansible
    brave
    jq
    nixpkgs-review
    nix-update
    unzip
  ];

  #services.zfs = {
  #  autoSnapshot.enable = true;
  #  autoScrub.enable = true;
  #  #trim.enable = true;
  #};

  # Virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "polar" ];
  virtualisation.libvirtd.enable = true;
  security.polkit.enable = true;

  users.users.polar = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd"];
    initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;
}
