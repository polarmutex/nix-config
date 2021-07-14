{ pkgs, config, lib, ... }:
let
  utils = import ../utils.nix { config = config; };

in
{
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim-nightly}/bin/nvim";
  };

  home.packages = with pkgs; [
    neovim-nightly

    clang-tools
    stylua
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.eslint_d
    nodePackages.markdownlint-cli
    nodePackages.pyright
    nodePackages.stylelint
    nodePackages.typescript-language-server
    nodePackages.vim-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver
    rnix-lsp
    sumneko-lua-language-server

    ripgrep
  ];

  xdg.configFile = utils.link-one "config" "." "nvim";

  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
}
