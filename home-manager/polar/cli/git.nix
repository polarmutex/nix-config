{ pkgs, config, lib, ... }:
with lib;
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
    ];
    signing = {
      signByDefault = true;
      key = "0x7F1160FAFC739341";
    };
  };

  home.packages = with pkgs; [
    git-crypt
    lazygit
  ];
}
