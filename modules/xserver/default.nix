{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.xserver;
in
{

  options.polar.services.xserver = { enable = mkEnableOption "X server"; };

  config = mkIf cfg.enable {

    hardware.video.hidpi.enable = lib.mkDefault true;

    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      dpi = 163;

      displayManager.lightdm.enable = true;

      desktopManager = {
        xterm.enable = false;
        session = [
          {
            name = "home-manager";
            start = ''
               ${pkgs.runtimeShell} $HOME/.hm-xsession &
              waitPID=$!
            '';
          }
          {
            name = "dwm";
            start = ''
               ${pkgs.my.dwm}/bin/dwm &
              waitPID=$!
            '';
          }
          {
            name = "awesome";
            start = ''
               ${pkgs.awesome}/bin/awesome &
              waitPID=$!
            '';
          }
        ];
      };
    };
  };
}
