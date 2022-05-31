{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.awesome;
in
{
  ###### interface
  options = {

    polar.awesome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable awesome xsession";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
      st
    ];

    xsession = {
      enable = true;
      windowManager = {
        awesome = {
          enable = true;
          package = pkgs.awesome-git;
          luaModules = [
            pkgs.awesome-battery-widget-git
            pkgs.bling-git
            pkgs.rubato-git
          ];
        };
      };
      initExtra = ''
        xrdb ~/.Xresources
      '';
    };
  };
}
