lib: config: inputs': self: let
  inherit
    (builtins)
    mapAttrs
    readDir
    ;

  sources = import ../npins;

  overlayAuto = final: prev: (
    readDir ./.
    |> lib.filterAttrs (_: value: value == "directory")
    |> mapAttrs (
      name: _:
        final.callPackage ./${name} {
        }
    )
  );

  # Import neovim-nightly overlay first to get the neovim package
  overlayNeovimNightly = import sources.neovim-nightly;

  overlayMisc = final: prev: rec {
    # nix-index = let
    #   imported = import sources.nix-index-database {pkgs = final;};
    # in
    #   imported.nix-index-with-db;

    luarc-json = let
      npinsToPlugins = input:
        builtins.mapAttrs (_: v: v {pkgs = final;})
        (import ./neovim/npins.nix {inherit input;});
      pinned-start-plugins = builtins.attrValues (npinsToPlugins ./neovim/start.json);
      pinned-opt-plugins = builtins.attrValues (
        {
          "blink.cmp" = final.blink-cmp;
        }
        // npinsToPlugins ./neovim/opt.json
      );
    in
      final.mk-luarc-json {
        nvim = final.neovim-polar;
        plugins = pinned-start-plugins ++ pinned-opt-plugins;
      };

    nh = final.callPackage "${sources.nh}/package.nix" {
      rev = sources.nh.revision;
    };

    maid = (import sources.nix-maid) final ../modules/maid;
    unstable = import sources.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      inherit config;
    };

    polarmutex-website = inputs'.website.packages.default;
  };

in
  lib.composeManyExtensions [
    overlayAuto
    overlayMisc
  ]
