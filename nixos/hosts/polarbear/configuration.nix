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
    nixpkgs-review
    nix-update
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
}
