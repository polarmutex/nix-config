{
  config,
  inputs,
  pkgs,
  ...
}: {
  home = let
    user = builtins.getEnv "USER";
    homedir = builtins.getEnv "HOME";
  in {
    username = user;
    homeDirectory = homedir;

    sessionPath = [
      "$HOME/.local/bin"
    ];

    packages = with pkgs; [
      cmake
      ctop
      fd
      glab
      kubernetes-helm
      lazygit
      inputs.neovim-flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim-polar
      ripgrep
      maven
    ];
  };
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

  programs = {
    fish = {
      shellInit = ''
        source ~/.nix-profile/etc/profile.d/nix.fish
      '';
      shellAliases.brave = "flatpak run --user com.brave.Browser";
    };

    # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
    git.extraConfig.credential.helper = "store";

    wezterm.textSize = 9;
  };
}
