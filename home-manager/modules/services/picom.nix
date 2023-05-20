_: {
  config,
  lib,
  ...
}: let
  cfg = config.services.picom;
in {
  config = lib.mkIf cfg.enable {
    services.picom = {
      # Shadows
      shadow = false;
      shadowOpacity = 0.75;
      shadowOffsets = [(-7) (-7)];
      shadowExclude = [
        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "_GTK_FRAME_EXTENTS@:c"
      ];

      # Fading
      fade = true;
      fadeSteps = [0.03 0.03];

      # Transparency / Opacity
      inactiveOpacity = 0.8;

      activeOpacity = 1.0;
      backend = "glx";
      opacityRules = [];
      vSync = true;

      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.75;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = false;
          clip-shadow-above = true;
        };
        dnd = {shadow = false;};
        popup_menu = {opacity = 1;};
        dropdown_menu = {opacity = 0.8;};
      };

      settings = {
        shadow-radius = 7;
        frame-opacity = 0.7;
        inactive-opacity-override = false;
        focus-exclude = ["class_g = 'Cairo-clock'"];
        corner-radius = 0;
        rounded-corners-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];
        blur-method = "dual_kawase";
        blur-strength = 4;
        blur-kern = "3x3box";
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_GTK_FRAME_EXTENTS@:c"
        ];
        dithered-present = false;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        detect-transient = true;
        use-damage = true;
      };
    };
  };
}
