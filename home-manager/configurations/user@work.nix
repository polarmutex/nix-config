{
  config,
  inputs,
  pkgs,
  ...
}: {
  #nixpkgs.allowedUnfree = [
  #  "obsidian"
  #];
  #activeProfiles = [
  #  "base"
  #  "fonts"
  #];
  #xsession.enable = lib.mkForce true;
  #xsession.windowManager.awesome.enable = lib.mkForce false;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    cmake
    ctop
    fd
    glab
    kubernetes-helm
    lazygit
    inputs.neovim-flake.packages.${pkgs.system}.neovim-polar
    ripgrep
  ];

  sops = {
    age.keyFile = "/home/user/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets.git_config_work = {
      path = "${config.home.homeDirectory}/.config/work_email.session";
    };
  };
  # secrets.aoc_session_token = {
  #   path = "${config.home.homeDirectory}/.config/adventofcode.session";
  # };

  #programs.htop.enable = true;
  #programs.fish.enable = true;
  #programs.kitty.configOnly = true;
  programs.kitty.textSize = 9;
  #programs.tmux.enable = true;
  programs.wezterm.textSize = 9;
  #programs.obsidian.enable = true;
  #programs.zellij.enable = true;
  #xsession.windowManager.awesome.enable = true;
}
