{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "${pkgs.exa}/bin/exa -lbGF --git --group-directories-first --icons";
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
      cat = "${pkgs.bat}/bin/bat";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
  };
}
