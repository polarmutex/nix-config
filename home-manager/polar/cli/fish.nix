{ config, pkgs, lib, ... }:
with lib;
{

  programs.fish = {
    enable = true;
    shellAbbrs = {
      # bat cat replacement
      "c" = "${pkgs.bat}/bin/bat -n --decorations never";
      "ga" = "git add";
      "gc" = "git commit";
      "gcam" = "git commit -am";
      "gcm" = "git commit -m";
      "gd" = "git diff";
      "gp" = "git push";
      "gpr" = "git pull --rebase";
      "glg" = "git log --color --graph --pretty --oneline";
      "glgb" = "git log --all --graph --decorate --oneline --simplify-by-decoration";
      "gst" = "git status";
      # Exa ls replacement
      "ll" = "${pkgs.exa}/bin/exa -lbGF --git --group-directories-first --icons";
      "ls" = "${pkgs.exa}/bin/exa --group-directories-first";
    };
    functions = {
      clean = "nix-store --gc --print-roots; and sudo nix-collect-garbage --delete-older-than 5d";
    };
    interactiveShellInit = ''
      ${getExe pkgs.starship} init fish | source
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
  };
}
