{
  flake.wrappers.neovim-polar = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: let
    sources = import ../../../npins;

    # Use mnw's npinsToPlugins which properly transforms npins sources to vim plugins
    mnwLib = (import sources.mnw).lib;
    startPlugins = mnwLib.npinsToPlugins pkgs ../../../packages/neovim/start.json;
    optPlugins = mnwLib.npinsToPlugins pkgs ../../../packages/neovim/opt.json;
  in {
    imports = [wlib.wrapperModules.neovim];

    config = {
      binName = "polar";

      # Use neovim-nightly
      package = let
        pkgsWithNeovim = pkgs.extend (import sources.neovim-nightly);
      in
        pkgsWithNeovim.neovim;

      # Lua packages
      settings.nvim_lua_env = lp: [lp.jsregexp];

      # Config directory - points to existing lua config
      settings.config_directory = ../../../packages/neovim;

      # Providers
      hosts.ruby.nvim-host.enable = true;
      hosts.python3.nvim-host.enable = true;
      hosts.node.nvim-host.enable = true;
      hosts.perl.nvim-host.enable = true;

      # Start plugins (npins) - already a list from mnw.npinsToPlugins
      specs.start-npins = {
        lazy = false;
        data = startPlugins;
      };

      # Treesitter with grammars
      specs.treesitter = {
        lazy = false;
        data = [
          (pkgs.unstable.vimPlugins.nvim-treesitter.withPlugins (p:
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
              luadoc
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
            ]))
        ];
      };

      # Opt plugins (npins + blink-cmp)
      specs.opt-npins = {
        lazy = true;
        data = [pkgs.blink-cmp] ++ optPlugins;
      };

      # Extra packages (PATH additions)
      prefixVar = [
        [
          "PATH"
          ":"
          (lib.makeBinPath (builtins.attrValues {
            inherit
              (pkgs)
              deadnix
              statix
              nil
              lua-language-server
              stylua
              ripgrep
              fd
              ;
          }))
        ]
      ];
    };
  };
}
