_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.fish;
in {
  config = lib.mkIf cfg.enable {
    programs.fish = {
      shellAliases = {
        ll = "${pkgs.exa}/bin/exa -lbGF --git --group-directories-first --icons";
        ls = "${pkgs.exa}/bin/exa --group-directories-first";
        cat = "${pkgs.bat}/bin/bat";
        #ga = "git add";
        #"gc" = "git commit";
        #"gcam" = "git commit -am";
        #"gcm" = "git commit -m";
        #"gd" = "git diff";
        #"gp" = "git push";
        #"gpr" = "git pull --rebase";
        #"glg" = "git log --color --graph --pretty --oneline";
        #"glgb" = "git log --all --graph --decorate --oneline --simplify-by-decoration";
        #"gst" = "git status";
      };
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.starship = {
      enable = true;
    };
  };
}