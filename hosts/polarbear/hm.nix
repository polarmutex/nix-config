{ pkgs, ... }:
{
  polar = {
    programs = {
      firefox.enable = true;
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
    services = {
      picom.enable = true;
      wallpapers.enable = true;
      dunst.enable = true;
      dwm-status.enable = true;
    };
  };

  home.packages = with pkgs; [
    _1password
    _1password-gui
    anki-bin
    arandr
    appimage-run
    brave
    exa
    gcc
    htop
    fd
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
    #yubioath-desktop
    ytfzf
    element-desktop
    qmk
    zoom-us
    ansible
    peek
  ];

  # Environment variables
  # systemd.user.sessionVariables = { ZDOTDIR = "/home/polar/.config/zsh"; };

  #home.sessionVariables = {
  #  EDITOR = "nvim";
  #  VISUAL = "nvim";
  #  ZDOTDIR = "/home/polar/.config/zsh";
  #};
}
