{pkgs, config, lib, ...}:
{

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
  };

  programs.neovim = {
    enable = true;

    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      black
      flake8
    ]);
  };

  home.packages = with pkgs; [
    nodejs
    clang-tools
  ];

}
