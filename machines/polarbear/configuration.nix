{ self, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  # environment.systemPackages = [self.wezterm];

  polar.desktop = {
    enable = true;
    hostname = "polarbear";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.printing.enable = true;
  services.tailscale.enable = true;
  #hardware.sane.enable = true;

  environment.systemPackages = with pkgs; [ tailscale ];

  # To build raspi images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
