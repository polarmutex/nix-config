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

  environment.systemPackages = with pkgs; [
    # Core utilities
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
  ];
}
