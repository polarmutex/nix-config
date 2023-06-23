{neovim-flake, ...}: {
  pkgs,
  lib,
  ...
}: {
  #nixpkgs.allowedUnfree = [
  #  "obsidian"
  #];
  activeProfiles = [
    "base"
    "fonts"
  ];
  xsession.enable = lib.mkForce true;
  #xsession.windowManager.awesome.enable = lib.mkForce false;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    ctop
    fd
    glab
    lazygit
    cmake
    #lens # need openlens
    #kube3d
    #kubectl
    kubernetes-helm
    neovim-flake.packages.${pkgs.system}.neovim-polar
    ripgrep
  ];

  programs.direnv.enable = true;
  programs.helix.enable = true;
  programs.htop.enable = true;
  programs.fish.enable = true;
  programs.kitty.configOnly = true;
  programs.kitty.textSize = 9;
  programs.tmux.enable = true;
  programs.wezterm.enable = true;
  programs.wezterm.textSize = 9;
  programs.obsidian.enable = true;
  programs.zellij.enable = true;
  xsession.windowManager.awesome.enable = true;
}
