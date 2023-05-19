{awesome-flake, ...}: {
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.xsession.windowManager.awesome;
in {
  #options.xsession.windowManager.awesome = {
  #  enable = mkEnableOption "AwesomeWM window manager";
  #};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [rofi];

    xdg.configFile.awesome.source = awesome-flake.packages.${pkgs.system}.awesome-config-polar;
  };
}
