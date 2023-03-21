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
