{pkgs, ...}: {
  services = {
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };
    xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = with pkgs; [
          mutter
        ];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.auto-move-windows
      gnomeExtensions.dash-to-dock
      gnomeExtensions.hide-universal-access
      gnomeExtensions.pop-shell
      gnomeExtensions.space-bar
      gnomeExtensions.user-themes
    ];

    gnome.excludePackages = with pkgs; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-calculator
      gnome-contacts
      # gnome-logs
      gnome-maps
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      # simple-scan
      tali # poker game
      totem # video player
    ];

    sessionVariables = {
      # MOZ_ENABLE_WAYLAND = "1";
      # # SSH_ASKPASS_REQUIRE = "prefer";
      # NIXOS_OZONE_WL = "1";
      # XCURSOR_THEME = "DMZ-White";
      # XCURSOR_SIZE = "24";
    };
    variables = {GNOME_SHELL_SLOWDOWN_FACTOR = "0.5";};
  };
  # # programs.geary.enable = false;
}
