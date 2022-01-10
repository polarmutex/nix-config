_:
{
  polar = {
    programs = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
    services = {
      wallpapers.enable = true;
    };
  };

  # Install these packages for my user
  # home.packages = with pkgs; [
  #   arandr
  #   brave
  #   exa
  #   lazygit
  #   networkmanagerapplet
  #   nix-index
  #   vscode
  #   htop
  #   cmake
  #   gh
  #   lazydocker
  #   ansible
  # ];
  #services = {
  #  # Applets, shown in tray
  #  # Networking
  #  network-manager-applet.enable = true;
  #  # Bluetooth
  #  blueman-applet.enable = true;
  #  # Pulseaudio
  #  pasystray.enable = true;
  #  # Battery Warning
  #  cbatticon.enable = true;
  #  # Keyring
  #  gnome-keyring = { enable = true; };
  #};

}
