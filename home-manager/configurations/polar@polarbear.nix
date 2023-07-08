{
  inputs,
  pkgs,
  ...
}: {
  #nixpkgs.allowedUnfree = [
  #  "discord"
  #  "obsidian"
  #  "1password"
  #  "onepassword-password-manager"
  #];

  #activeProfiles = [
  #  "base"
  #  "fonts"
  #  "messaging"
  #  "trusted"
  #  "wallpapers"
  #];
  #profiles.base.enable = true;

  programs.kitty.enable = true;
  programs.kitty.textSize = 11;
  programs.wezterm.enable = true;

  #xsession.windowManager.awesome.enable = true;

  home.packages = with pkgs; [
    cmake
    conan
    erdtree
    flameshot
    gcc
    gnome.nautilus
    gramps
    lazygit
    inputs.neovim-flake.packages.${pkgs.system}.neovim-polar
    nix-melt
    nixpkgs-fmt
    zotero
  ];
}
