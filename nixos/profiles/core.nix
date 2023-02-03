{ pkgs
, lib
, ...
}: {
  environment = {
    systemPackages = with pkgs; [
      bat
      binutils
      coreutils
      curl
      exa
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
