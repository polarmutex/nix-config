{
  lib,
  pkgs,
  ...
}: let
  npinsToPlugins = input: builtins.mapAttrs (_: v: v {inherit pkgs;}) (import ./npins.nix {inherit input;});
in {
  appName = "polar";

  extraLuaPackages = p: [p.jsregexp];

  providers = {
    ruby.enable = true;
    python3.enable = true;
    nodeJs.enable = true;
    perl.enable = true;
  };

  # Source lua config
  initLua = ''
    require("polar")
    LZN = require("lz.n")
    --LZN.register_handler(require("handlers.which-key"))
    LZN.load("polar.lazy")
  '';

  desktopEntry = false;
  plugins = {
    dev.polar = {
      pure = let
        fs = lib.fileset;
      in
        fs.toSource {
          root = ./.;
          fileset = fs.unions [
            ./lua
            # ./after
          ];
        };
      impure = "~/repos/personal/nix-config/main/packages/neovim";
    };

    startAttrs = npinsToPlugins ./start.json;

    # start = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    start = [
      (pkgs.unstable.vimPlugins.nvim-treesitter.withPlugins
        (p: [
          p.beancount
          p.c
          p.cmake
          p.cpp
          p.csv
          p.dockerfile
          p.git_config
          p.gitcommit
          p.helm
          p.html
          p.java
          p.json
          p.lua
          p.make
          p.markdown
          p.nix
          p.python
          p.rust
          p.sql
          p.typescript
          p.yaml
          p.zig
        ]))
    ];

    optAttrs =
      {
        "blink.cmp" = pkgs.blink-cmp;
      }
      // npinsToPlugins ./opt.json;
  };

  extraBinPath = builtins.attrValues {
    #
    # Runtime dependencies
    #
    inherit
      (pkgs)
      deadnix
      statix
      nil
      lua-language-server
      stylua
      #rustfmt
      ripgrep
      fd
      # chafa
      # vscode-langservers-extracted
      ;
  };
}
