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

  misc.leftwm.enable = true;
  polar.eww.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  programs.helix.enable = true;
  programs.htop.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.kitty.enable = true;
  programs.tmux.enable = true;
  programs.wezterm.enable = true;
  programs.obsidian.enable = true;
  programs.logseq.enable = true;
  programs.zellij.enable = true;
  services.picom.enable = true;

  home.packages = with pkgs; [
    flameshot
    lazygit
    gnome.nautilus
    neovim-flake.packages.${pkgs.system}.default
  ];
}
