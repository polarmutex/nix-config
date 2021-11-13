{ self, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  polar.desktop = {
    enable = true;
    hostname = "polarbear";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.printing.enable = true;
  services.tailscale.enable = true;
  #hardware.sane.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ tailscale virt-manager ];

  # To build raspi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
