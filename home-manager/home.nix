{ config, pkgs, lib, ... }:
{

  # Imports
  imports = [
    # ./modules/autorandr.nix
    ./modules/fonts.nix
    ./modules/wallpapers.nix
    ./modules/neovim.nix
    ./modules/rofi.nix
    ./modules/awesome.nix
    ./modules/st.nix
    ./modules/git.nix
    ./modules/gpg
    ./modules/obsidian.nix
    ./modules/picom.nix
    ./modules/tmux.nix
    #./modules/chromium.nix
    #./modules/credentials.nix
    #./modules/dunst.nix
    #./modules/gtk.nix
    #./modules/neomutt.nix
    #./modules/shell.nix
    #./modules/tmux
    #./modules/xdg.nix
    #./modules/xresources.nix
    #./modules/xscreensaver.nix
    #./modules/firefox
  ];

  #polar.programs = {
  #firefox.enable = true;
  #tmux.enable = true;
  #rofi.enable = true;
  #};

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [

    _1password
    _1password-gui
    anki-bin
    arandr
    brave
    exa
    gcc
    htop
    fd
    lazygit
    networkmanagerapplet
    nix-index
    pavucontrol
    playerctl
    spotify
    xfce.exo # thunar "open terminal here"
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler # thunar thumbnails
    xfce.xfce4-volumed-pulse
    xfce.xfconf # thunar save settings
    xorg.xrandr
    yubioath-desktop
    virt-manager
    ytfzf
    element-desktop
    qmk
    rustup
    rust-analyzer
    zoom-us
  ];

  # Environment variables
  systemd.user.sessionVariables = { ZDOTDIR = "/home/polar/.config/zsh"; };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    ZDOTDIR = "/home/polar/.config/zsh";
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
  home.stateVersion = "21.05";
}
