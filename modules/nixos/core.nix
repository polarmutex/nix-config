{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      bat
      binutils
      coreutils
      curl
      fd
      gitAndTools.gitFull
      gnumake
      neovim
      ripgrep
      rsync
      wget
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
