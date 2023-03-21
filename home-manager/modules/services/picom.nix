_: {
  config,
  lib,
  ...
}: let
  cfg = config.services.picom;
in {
  config = lib.mkIf cfg.enable {
    services.picom = {
      activeOpacity = 1.0;
      inactiveOpacity = 0.8;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      opacityRules = [];
      shadow = true;
      shadowOpacity = 0.75;
    };
  };
}
