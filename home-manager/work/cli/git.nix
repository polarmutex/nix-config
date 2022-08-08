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
      {
        condition = "gitdir:~/repos/work/";
        contents = {
          user = {
            name = "Brian Ryall";
            email = (builtins.fromJSON (builtins.readFile ../../../.secrets/work/info.json)).work_email;
          };
        };
      }
    ];
    #signing = {
    #  signByDefault = true;
    #  key = "0x7F1160FAFC739341";
    #};
  };

  home.packages = with pkgs; [
    git-crypt
    lazygit
  ];
}
