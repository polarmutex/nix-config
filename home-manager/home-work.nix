{ config, pkgs, lib, self, ... }:
{

  # Imports
  imports = [
    # ./modules/autorandr.nix
    ./modules/fonts.nix
    ./modules/wallpapers.nix
    ./modules/neovim.nix
    ./modules/dmenu.nix
    ./modules/dwm-status.nix
    ./modules/dwm.nix
    ./modules/st.nix
    ./modules/git.nix
    ./modules/gpg
    ./modules/obsidian.nix
    ./modules/logseq.nix
    ./modules/tmux.nix
    ./modules/shell.nix
    ./modules/work.nix
    ../.secrets/work/tmux-sessionizer-work.nix
  ];

  # Allow "unfree" licenced packages
  nixpkgs.config = {
    allowUnfree = true;
  };


  # Install these packages for my user
  home.packages = with pkgs; [

    arandr
    brave
    exa
    lazygit
    networkmanagerapplet
    nix-index
    vscode
    htop
    cmake
  ];

  # Environment variables
  #systemd.user.sessionVariables = { ZDOTDIR = "/home/brian/.config/zsh"; };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    #ZDOTDIR = "/home/brian/.config/zsh";
  };

  programs.neovim.package = pkgs.neovim-nightly;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.tmux.extraConfig = builtins.readFile ../.secrets/work/tmux_config;

  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # Pulseaudio
    pasystray.enable = true;

    # Battery Warning
    cbatticon.enable = true;

    # Keyring
    gnome-keyring = { enable = true; };

  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
