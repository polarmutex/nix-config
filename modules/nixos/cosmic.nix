{pkgs, ...}: {
  nix.settings = {
    substituters = ["https://cosmic.cachix.org"];
    trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
  };
  services = {
    flatpak.enable = true;
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
