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
    maven
  ];

  sops = let
    user = builtins.getEnv "USER";
  in {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    secrets.git_config_work = {
      path = "${config.home.homeDirectory}/.config/work_email.session";
    };
  };
  # secrets.aoc_session_token = {
  #   path = "${config.home.homeDirectory}/.config/adventofcode.session";
  # };

  programs.fish.shellInit = ''
    source ~/.nix-profile/etc/profile.d/nix.fish
  '';
  programs.fish.shellAliases.brave = "flatpak run --user com.brave.Browser";

  # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
  programs.git.extraConfig.credential.helper = "store";

  #programs.htop.enable = true;
  #programs.fish.enable = true;
  #programs.kitty.configOnly = true;
  #programs.kitty.textSize = 9;
  #programs.tmux.enable = true;
  programs.wezterm.textSize = 9;
  # programs.wezterm.configOnly = true;
  #programs.obsidian.enable = true;
  #programs.zellij.enable = true;
  #xsession.windowManager.awesome.enable = true;
}
