_: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.display-manager;
in {
  options.profiles.display-manager = {
    enable = lib.mkEnableOption "enable displayManager";
  };
  config = lib.mkIf cfg.enable {
    services.xserver = {
      displayManager = {
        #autoLogin = {
        #  enable = true;
        #  user = "polar";
        #};
        lightdm = {
          enable = true;
        };
      };
    };
  };
}
