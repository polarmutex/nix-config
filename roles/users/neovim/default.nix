{pkgs, config, lib, ...}:
let
  utils = import ../utils.nix { config = config; };

in {
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
  };

  home.packages = with pkgs; [
    neovim-nightly
    nodejs
    clang-tools
  ];

  xdg.configFile.nvim.source = utils.link "config/nvim";

}
