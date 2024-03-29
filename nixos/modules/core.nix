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
  };

  networking.networkmanager.enable = true;
}
