{ config, pkgs, lib, ... }:
let

in {
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
        automatic = true;
        options = "--delete-older-than 5d";
    };
    package = pkgs.nixFlakes;
  };

  # Add zsh to the /etc/shells
  environment.shells = with pkgs; [
    zsh
    bash
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    # Core utilities
    brave
    vim
    wget
    curl
    killall
    neofetch
    htop
    unzip
    file
    zip
    git
    git-crypt
    tmux
    zsh
    gh
    lm_sensors
    xorg.xdpyinfo
    feh
  ];
}
