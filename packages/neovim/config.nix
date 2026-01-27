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
    start =
      (pkgs.unstable.vimPlugins.nvim-treesitter.withPlugins
        (p:
          with p; [
            bash
            beancount
            c
            cmake
            comment
            cpp
            csv
            dockerfile
            git_config
            gitcommit
            helm
            html
            java
            json
            lua
            luadoc # --- type annotations
            make
            markdown
            nix
            python
            rust
            sql
            tsx
            typescript
            yaml
            zig
          ])).dependencies;

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
