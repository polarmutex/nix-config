_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.messaging;
in {
  options.profiles.messaging = {
    enable = lib.mkEnableOption "A profile that enables a messaging apps";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      element-desktop
    ];
  };
}
