{pkgs, ...}: {
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      # wayland = false;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = with pkgs; [
        mutter
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.dash-to-panel
      gnomeExtensions.pop-shell
      #     # adw-gtk3
      #     # wl-clipboard
      #     # vanilla-dmz
      #     # gnomeExtensions.appindicator
      #     # gnomeExtensions.astra-monitor
    ];

    gnome.excludePackages = with pkgs; [
      # totem
      gnome-maps
      # gnome-logs
      # simple-scan
      gnome-calculator
      # epiphany
      gnome-music
      gnome-tour
      gnome-contacts
      # gnome-disk-utility
    ];

    sessionVariables = {
      # MOZ_ENABLE_WAYLAND = "1";
      # # SSH_ASKPASS_REQUIRE = "prefer";
      # NIXOS_OZONE_WL = "1";
      # XCURSOR_THEME = "DMZ-White";
      # XCURSOR_SIZE = "24";
    };
  };
  # # programs.geary.enable = false;
}
