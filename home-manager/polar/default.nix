{ inputs, pkgs, lib, username, features, ... }:

let
  inherit (lib) optional mkIf;
  inherit (builtins) map pathExists filter;
in
{
  imports = [
    ./cli
  ]
  # Import features that have modules
  ++ filter pathExists (map (feature: ./${feature}) features);

  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    ansible
    bfg-repo-cleaner
  ];

  home = {
    inherit username;
    stateVersion = "22.05";
    homeDirectory = "/home/${username}";
  };
}
