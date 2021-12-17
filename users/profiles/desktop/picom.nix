{ pkgs, config, lib, ... }:
{
  services.picom = {
    package = pkgs.picom-next;
    enable = true;
    shadow = true;
    backend = "glx";
    activeOpacity = "0.9";
    experimentalBackends = true;
    extraOptions = ''
      detect-client-opacity = true;
      detect-rounded-corners = true;
      blur:
      {
          method = "kawase";
          strength = 8;
          background = true;
          background-frame = false;
          background-fixed = false;
      };
      blur-background-exclude = [
          "class_g = 'keynav'"
      ];
      corner-radius = 18;
      rounded-corners-exclude = [
          "window_type = 'dock'",
          "_NET_WM_STATE@:32a *= '_NET_WM_STATE_FULLSCREEN'",
          "class_g = 'keynav'",
      ];
      round-borders = 1;
      round-borders-exclude = [
          "class_g = 'keynav'"
      ];
    '';
  };
}
