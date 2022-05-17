{ pkgs, ... }:
{
  polar = {
    programs = {
      direnv.enable = true;
      git.enable = true;
      neovim = {
        enable = true;
        lsp = {
          lua = true;
          python = true;
          java = true;
        };
      };
      tmux.enable = true;
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
    dwm.enable = true;
    work.enable = true;
  };

  home.packages = with pkgs; [
    ansible
    arandr
    appimage-run
    brave
    cmake
    exa
    gh
    graphviz
    htop
    lazydocker
    networkmanagerapplet
    nix-index
    pavucontrol
    playerctl
    stacks
    vscodium
    xorg.xrandr
    #yubioath-desktop
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
