{
  pkgs,
  lib,
  ...
}: {
  # Common server packages
  environment = {
    systemPackages = with pkgs; [
      bat
      bottom
      curl
      dnsutils
      git
      htop
      jq
      ripgrep
      unzip
    ];
    # List of available shells
    shells = with pkgs; [
      bash
      zsh
      fish
    ];
    # Use helix as the default editor
    variables.EDITOR = "nvim";
  };

  time.timeZone = lib.mkDefault "US/Eastern";

  # No mutable users by default
  users.mutableUsers = false;

  # Define default system version
  system.stateVersion = "23.05";
}
