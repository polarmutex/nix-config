{ config, pkgs, lib, self, ... }:
{

  # Imports
  imports = [
    # ./modules/autorandr.nix
    ./modules/fonts.nix
    ./modules/wallpapers.nix
    ./modules/neovim.nix
    ./modules/dmenu.nix
    ./modules/dwmblocks.nix
    ./modules/dwm.nix
    ./modules/st.nix
    ./modules/git.nix
    ./modules/gpg
    ./modules/obsidian.nix
    ./modules/logseq.nix
    ./modules/tmux.nix
    ./modules/shell.nix
  ];

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };


  # Install these packages for my user
  home.packages = with pkgs; [

    arandr
    brave
    exa
    lazygit
    networkmanagerapplet
    nix-index
    xfce.exo # thunar "open terminal here"
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler # thunar thumbnails
    xfce.xfce4-volumed-pulse
    xfce.xfconf # thunar save settings
    vscode
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
