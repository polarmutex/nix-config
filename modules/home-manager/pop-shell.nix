{
  lib,
  pkgs,
  ...
}:
with lib.hm.gvariant; {
  # Enable extensions
  dconf.settings = {
    #
    # DESKTOP
    #
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/privacy" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = false;
    };
    "org/gnome/desktop/session" = {
      # idle-delay = 900; # 15mins
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      minimize = [];
      move-to-workspace-1 = ["<Super><Shift>a"];
      move-to-workspace-2 = ["<Super><Shift>r"];
      move-to-workspace-3 = ["<Super><Shift>s"];
      move-to-workspace-4 = ["<Super><Shift>t"];
      move-to-workspace-5 = ["<Super><Shift>n"];
      move-to-workspace-6 = ["<Super><Shift>e"];
      move-to-workspace-7 = ["<Super><Shift>i"];
      move-to-workspace-8 = ["<Super><Shift>o"];
      move-to-workspace-9 = [];
      move-to-workspace-10 = [];
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
      switch-to-workspace-1 = ["<Super>a"];
      switch-to-workspace-2 = ["<Super>r"];
      switch-to-workspace-3 = ["<Super>s"];
      switch-to-workspace-4 = ["<Super>t"];
      switch-to-workspace-5 = ["<Super>n"];
      switch-to-workspace-6 = ["<Super>e"];
      switch-to-workspace-7 = ["<Super>i"];
      switch-to-workspace-8 = ["<Super>o"];
      switch-to-workspace-9 = [];
      switch-to-workspace-10 = [];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 8;
      # button-layout = "appmenu:";
      # focus-mode = "mouse";
      # auto-raise = false;
      # resize-with-right-button = false;
      workspace-names = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
      ];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
    };
    #
    # SHELL
    #
    "org/gnome/shell" = let
      extensions = with pkgs.gnomeExtensions; [
        appindicator
        auto-move-windows
        dash-to-dock
        hide-universal-access
        pop-shell
        space-bar
        user-themes
      ];
    in {
      disable-user-extensions = false;
      enabled-extensions = map (e: e.extensionUuid) extensions;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "code.desktop"
        "1password.desktop"
      ];
    };
    #
    # SHELL EXTENSIONS
    #
    "org/gnome/shell/extensions/auto-move-windows" = let
      toWorkspace = w: apps:
        map (name: "${name}.desktop:${toString w}") apps;
    in {
      application-list =
        # 1. Web (Browsers)
        (toWorkspace 2 [
          "brave-browser"
          "google-chrome"
          "firefox-devedition"
        ])
        ++
        # 2. Dev (Terminals, editors, ..etc)
        (toWorkspace 1 [
          "code"
          "org.gnome.Console"
          "org.wezfurlong.wezterm"
        ])
        ++
        # 3. Notes (Obsidian)
        (toWorkspace 3 [
          "obsidian"
        ])
        ++
        # 4. Social (Slack, Discord ..etc)
        (toWorkspace 4 [
          "discord"
          "slack"
        ])
        ++
        # 10. Temporarily access (Spotify, 1Password, Settings ..etc)
        (toWorkspace 8 [
          "1password"
          "bluetooth-sendto"
          "gcm-calibrate"
          "gcm-picker"
          "gnome-applications-panel"
          "gnome-background-panel"
          "gnome-bluetooth-panel"
          "gnome-color-panel"
          "gnome-datetime-panel"
          "gnome-default-apps-panel"
          "gnome-diagnostics-panel"
          "gnome-display-panel"
          "gnome-firmware-security-panel"
          "gnome-info-overview-panel"
          "gnome-keyboard-panel"
          "gnome-location-panel"
          "gnome-microphone-panel"
          "gnome-mouse-panel"
          "gnome-multitasking-panel"
          "gnome-network-panel"
          "gnome-notifications-panel"
          "gnome-online-accounts-panel"
          "gnome-power-panel"
          "gnome-printers-panel"
          "gnome-region-panel"
          "gnome-removable-media-panel"
          "gnome-screen-panel"
          "gnome-search-panel"
          "gnome-sharing-panel"
          "gnome-sound-panel"
          "gnome-system-monitor-kde"
          "gnome-thunderbolt-panel"
          "gnome-universal-access-panel"
          "gnome-usage-panel"
          "gnome-user-accounts-panel"
          "gnome-wacom-panel"
          "gnome-wifi-panel"
          "gnome-wwan-panel"
          "org.gnome.ColorProfileViewer"
          "org.gnome.Evince-previewer"
          "org.gnome.Extensions"
          "org.gnome.Settings"
          "org.gnome.Shell.Extensions"
          "org.gnome.tweaks"
          "spotify"
        ]);
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      # Position and size
      dock-position = "LEFT";
      dock-fixed = false;
      dash-max-icon-size = 54;

      # Launchers
      show-trash = true;
      show-mounts = true;

      # Behavior
      # scroll-action = "do-nothing";
      # click-action = "focus-minimize-or-previews";
      # intellihide-mode = "ALL_WINDOWS";
      # hot-keys = false;

      # Appearance
      # custom-theme-shrink = true;
      # running-indicator-style = "DOTS";
      # transparency-mode = "FIXED";
      # background-opacity = 1.0;
      # custom-background-color = false;
      # background-color = "#1e1e2e";
      # disable-overview-on-startup = true;
    };
    "org/gnome/shell/extensions/pop-shell" = {
      activate-launcher = [];
      active-hint-border-radius = mkUint32 5;
      active-hint = true;
      fullscreen-launcher = false;
      gap-inner = mkUint32 2;
      gap-outer = mkUint32 2;
      mouse-cursor-focus-location = mkUint32 4;
      mouse-cursor-follows-active-window = false;
      tile-by-default = true;
    };
    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = false;
      show-empty-workspaces = true;
      position = "left";
      position-index = 0;
      scroll-wheel = "disabled";
      smart-workspace-names = false;
    };
    "org/gnome/shell/extensions/space-bar/appearance" = {
      workspaces-bar-padding = mkUint32 12;
      workspace-margin = mkUint32 4;
      # active-workspace-text-color = "rgb(0,0,0)";
      # active-workspace-background-color =
      #   "rgb(187,160,232)";
      # inactive-workspace-border-radius = mkUint32 4;
      # inactive-workspace-font-weight = "700";
      # inactive-workspace-background-color = "rgba(255,255,255,0.0)";
      # inactive-workspace-text-color = "rgb(192,191,188)";
    };
    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-activate-workspace-shortcuts = false;
      enable-move-to-workspace-shortcuts = false;
      activate-empty-key = [];
      activate-previous-key = [];
      open-menu = [];
    };
    "org/gnome/shell/extensions/user-theme".name = "Tokyonight-Dark";
    "org/gnome/mutter" = {
      edge-tiling = false;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme.override {
        # macos style window buttons
        tweakVariants = ["macos"];
      };
      name = "Tokyonight-Dark";
    };
  };
}
