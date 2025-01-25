{
  pkgs,
  lib,
  ...
}: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        ll = "${pkgs.eza}/bin/eza -lbGF --git --group-directories-first --icons";
        ls = "${pkgs.eza}/bin/eza --group-directories-first";
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
    skim = {
      enable = true;
      enableFishIntegration = true;
    };
    starship = {
      enable = true;
    };
  };
  xdg.configFile."shell".source = lib.getExe pkgs.fish;
}
