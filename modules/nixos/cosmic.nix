{
  lib,
  pkgs,
  ...
}: {
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
    # wl-clipboard
    # andromeda
    # chronos
    # cosmic-ext-applet-caffeine
    # cosmic-ext-applet-clipboard-manager
    # cosmic-ext-applet-emoji-selector
    # cosmic-ext-applet-external-monitor-brightness
    # cosmic-ext-calculator
    cosmic-ext-ctl
    # examine
    # forecast
    # tasks
    cosmic-ext-tweaks
    (lib.lowPrio cosmic-comp)
    # cosmic-reader
    drm_info
    # quick-webapps
    # stellarshot
  ];
  # ++ lib.optionals stdenv.hostPlatform.isx86 [
  #   observatory
  # ]

  environment.sessionVariables = {
    COSMIC_DATA_CONTROL_ENABLED = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
  # 1password
  # https://discourse.nixos.org/t/1password-cant-save-mfa-code/58254/2
  # dbus-update-activation-environment --all
}
