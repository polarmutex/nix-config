{ pkgs, config, lib, ... }:
let
  utils = import ./utils.nix { inherit config; };
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
    my.jdtls
    nodePackages.svelte-language-server
    my.prettierd
    ripgrep
    python39Packages.python-lsp-server
    python39Packages.pyls-flake8
    python39Packages.flake8
    #TODO python39Packages.pylsp-mypy
    #TODO python39Packages.mypy
    python39Packages.pyls-isort
    python39Packages.python-lsp-black
  ];

  xdg.configFile = utils.link-one "config" "." "nvim";

  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/java.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/c.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-c}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/typescript.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-typescript}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/html.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-html}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/markdown.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-markdown}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/svelte.so".source = "${pkgs.my.tree-sitter-svelte}/parser";
  xdg.dataFile."nvim/site/pack/packer/start/nvim-treesitter/parser/beancount.so".source = "${pkgs.my.tree-sitter-beancount}/parser";
}
