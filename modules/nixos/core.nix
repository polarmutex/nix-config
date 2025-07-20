{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      bat
      carapace
      curl
      difftastic
      direnv
      du-dust
      eza
      fd
      fq
      unstable.gh
      unstable.glab
      gnumake
      hexyl
      unstable.htop
      fzf
      jq
      just
      unstable.lazygit
      lurk
      magic-wormhole-rs
      unstable.neovim
      nix-index
      psmisc
      unstable.ripgrep
      rsync
      sops
      starship
      unar
      unstable.vim
      wget
      yazi
    ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    sessionVariables.EDITOR = "nvim";
  };

  networking.networkmanager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 3";
    package = pkgs.unstable.nh;
  };
}
