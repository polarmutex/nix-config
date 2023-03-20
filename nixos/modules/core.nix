{...}: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.profiles.core;
in {
  options.profiles.core = {
    enable = lib.mkEnableOption "enable core";
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        bat
        binutils
        coreutils
        curl
        exa
        fd
        gitAndTools.gitFull
        gnumake
        neovim
        ripgrep
        rsync
        wget
      ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    networking.networkmanager.enable = true;
  };
}
