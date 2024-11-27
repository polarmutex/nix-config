{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mainMod" = "SUPER";

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        ",preferred,auto,auto"
        "Unknown-1,disabled"
        # ",highrr,auto,auto"
      ];

      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 3;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;
        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        # initial_workspace_tracking = 2;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = false;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "$mainMod, C, killactive,"
        "$mainMod, D, exec, rofi -show drun"
        "$mainMod, M, exit,"
        "$mainMod, Return, exec, kitty"

        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"

        "$mainMod SHIFT, H, resizeactive, -10 0"
        "$mainMod SHIFT, J, resizeactive, 0 10"
        "$mainMod SHIFT, K, resizeactive, 0 -10"
        "$mainMod SHIFT, L, resizeactive, 10 0"

        "$mainMod, A, workspace, 1"
        "$mainMod, R, workspace, 2"
        "$mainMod, S, workspace, 3"
        "$mainMod, T, workspace, 4"
        "$mainMod, N, workspace, 5"
        "$mainMod, E, workspace, 6"
        "$mainMod, I, workspace, 7"
        "$mainMod, O, workspace, 8"

        "SUPER $mainMod SHIFT, A, movetoworkspacesilent, 1"
        "SUPER $mainMod SHIFT, R, movetoworkspacesilent, 2"
        "SUPER $mainMod SHIFT, S, movetoworkspacesilent, 3"
        "SUPER $mainMod SHIFT, T, movetoworkspacesilent, 4"
        "SUPER $mainMod SHIFT, N, movetoworkspacesilent, 5"
        "SUPER $mainMod SHIFT, E, movetoworkspacesilent, 6"
        "SUPER $mainMod SHIFT, I, movetoworkspacesilent, 7"
        "SUPER $mainMod SHIFT, O, movetoworkspacesilent, 8"
      ];

      windowrule = [
        # Window rules
        "tile,title:^(kitty)$"
        # "float,title:^(fly_is_kitty)$"
        # "tile,^(Spotify)$"
        # "tile,^(wps)$"
      ];

      exec-once = [
        "autostart"
        "hyprpaper"
      ];
    };
  };

  xdg.configFile = {
    "hypr/scripts/launch_waybar".text = ''
      waybar -c $HOME/.config/waybar/config -s $HOME/.config/waybar/style.css &
    '';
    "hypr/scripts/launch_waybar".executable = true;
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr
      scripts=$config/scripts

      # Waybar (if enabled)
      pkill waybar
      $scripts/launch_waybar &
    '')
    dolphin
  ];
}
