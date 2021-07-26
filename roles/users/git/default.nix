{ pkgs, config, lib, ... }:
let
  utils = import ../utils.nix { config = config; };
in
{

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
      {
        path = "~/.config/git/config_work";
      }
    ];
  };

  home.packages = with pkgs; [
    lazygit
  ];

}
