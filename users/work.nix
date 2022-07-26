{ pkgs, ... }:
{
  home.username = "blueguardian";
  home.homeDirectory = "/home/blueguardian";
  polar = {
    programs = {
      direnv.enable = true;
      git.enable = true;
      firefox.enable = true;
      neovim = {
        enable = true;
        lsp = {
          lua = true;
          python = true;
          java = true;
          rust = true;
        };
      };
      nix.enable = true;
      tmux.enable = true;
      wezterm.enable = true;
      zsh.enable = true;
    };
    services = {
      gpg.enable = true;
      wallpapers.enable = true;
      dunst.enable = true;
      dwm-status.enable = true;
      dendron.enable = true;
      dendron.work = true;
    };
    fonts.enable = true;
    awesome.enable = true;
    work.enable = true;
  };

  home.packages = with pkgs; [
    ansible
    arandr
    appimage-run
    awesome-git
    brave
    cmake
    exa
    gh
    graphviz
    htop
    lazydocker
    libreoffice-fresh
    networkmanagerapplet
    nix-index
    pavucontrol
    playerctl
    poetry
    stacks
    vscodium
    xorg.xrandr
    #yubioath-desktop
    xfce.exo # thunar "open terminal here"
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.tumbler # thunar thumbnails
    xfce.xfce4-volumed-pulse
    xfce.xfconf # thunar save settings
    zathura
  ];

  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # Pulseaudio
    pasystray.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    #ZDOTDIR = "/home/brian/.config/zsh";
  };

}
