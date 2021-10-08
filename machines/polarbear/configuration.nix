# Configuration for kartoffel
{ self, ... }: {

  imports = [ ./hardware-configuration.nix ];

  # environment.systemPackages = [self.wezterm];

  polar.desktop = {
    enable = true;
    hostname = "polarbear";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.printing.enable = true;
  #hardware.sane.enable = true;

  # To build raspi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
