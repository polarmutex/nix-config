{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      bat
      binutils
      coreutils
      curl
      eza
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
