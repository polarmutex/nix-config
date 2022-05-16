{ pkgs, ... }:
{
  polar = {
    programs = {
      direnv.enable = true;
      firefox.enable = true;
      git.enable = true;
      neomutt.enable = true;
      neovim = {
        enable = true;
        lsp = {
          nix = true;
          rust = true;
          lua = true;
        };
      };
      tmux.enable = true;
      zsh.enable = true;
    };
    services = {
      gpg.enable = true;
      dendron.enable = true;
      obsidian.enable = true;
      picom.enable = true;
      wallpapers.enable = true;
      dunst.enable = true;
      dwm-status.enable = true;
      stacks.enable = true;
    };
    fonts.enable = true;
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
    vscodium
    protonvpn-cli
    xclip

    # gaming
    lutris
    wineWowPackages.staging
    winetricks
    vulkan-tools
    vulkan-loader
    vulkan-headers
    glxinfo
  ];

  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # Pulseaudio
    pasystray.enable = true;

    # Keyring
    gnome-keyring = { enable = true; };
  };

  # Environment variables
  # systemd.user.sessionVariables = { ZDOTDIR = "/home/polar/.config/zsh"; };

  #home.sessionVariables = {
  #  EDITOR = "nvim";
  #  VISUAL = "nvim";
  #  ZDOTDIR = "/home/polar/.config/zsh";
  #};
}
