{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.programs.git;
in
{

  ###### interface
  options = {

    polar.programs.git = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable git";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Brian Ryall";
      userEmail = "brian@brianryall.xyz";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
      includes = [
      ];
    };

    home.packages = with pkgs; [
      lazygit
    ];
  };

}
