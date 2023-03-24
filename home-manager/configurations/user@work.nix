{neovim-flake, ...}: {
  lib,
  pkgs,
  ...
}: {
  #nixpkgs.allowedUnfree = [
  #  "obsidian"
  #];
  activeProfiles = [
    "base"
    "fonts"
  ];
  #xsession.enable = lib.mkForce false;
  #xsession.windowManager.awesome.enable = lib.mkForce false;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    ctop
    fd
    glab
    lazygit
    #lens # need openlens
    #kube3d
    #kubectl
    #kubernetes-helm
    neovim-flake.packages.${pkgs.system}.default
    ripgrep
  ];

  programs.direnv.enable = true;
  programs.helix.enable = true;
  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.wezterm.enable = true;
  programs.wezterm.textSize = 9;
  programs.obsidian.enable = true;
  programs.zellij.enable = true;
}
