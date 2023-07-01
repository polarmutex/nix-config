{neovim-flake, ...}: {pkgs, ...}: {
  #nixpkgs.allowedUnfree = [
  #  "discord"
  #  "obsidian"
  #  "1password"
  #  "onepassword-password-manager"
  #];
  activeProfiles = [
    "base"
    "fonts"
    "messaging"
    "trusted"
    "wallpapers"
  ];
  profiles.base.enable = true;
  #profiles.fonts.enable = true;
  #xsession.enable = lib.mkForce false;
  #xsession.windowManager.awesome.enable = lib.mkForce false;

  #misc.leftwm.enable = true;
  #polar.eww.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  programs.helix.enable = true;
  programs.htop.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.kitty.enable = true;
  programs.kitty.textSize = 11;
  programs.tmux.enable = true;
  programs.wezterm.enable = true;
  programs.obsidian.enable = true;
  programs.logseq.enable = true;
  programs.zellij.enable = true;
  services.picom.enable = true;
  xsession.windowManager.awesome.enable = true;

  home.packages = with pkgs; [
    cmake
    conan
    erdtree
    flameshot
    gcc
    gnome.nautilus
    gramps
    lazygit
    neovim-flake.packages.${pkgs.system}.neovim-polar
    nix-melt
    nixpkgs-fmt
    zotero
  ];
}
