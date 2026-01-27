lib: config: inputs': let
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

    neovim = let
      # Apply the neovim-nightly overlay to get the nightly neovim
      pkgsWithNeovim = prev.extend overlayNeovimNightly;
    in
      (import sources.mnw).lib.wrap final {
        neovim = pkgsWithNeovim.neovim;
        imports = [./neovim/config.nix];
      };
    luarc-json = let
      pinned-start-plugins = (import sources.mnw).lib.npinsToPlugins final ./neovim/start.json;
      pinned-opt-plugins = (import sources.mnw).lib.npinsToPlugins final ./neovim/opt.json;
      # npinsToPlugins = input: builtins.mapAttrs (_: v: v {inherit pkgs;}) (import ./neovim/npins.nix {inherit input;});
      # startAttrs = builtins.attrValues (npinsToPlugins ./neovim/start.json);
      # optAttrs = builtins.attrValues (
      #   {
      #     "blink.cmp" = pkgs.blink-cmp;
      #   }
      #   // npinsToPlugins ./neovim/opt.json
      # );
    in
      final.mk-luarc-json {
        nvim = neovim;
        # plugins = builtins.attrValues npinPlugins';
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

  overlayWrapperManager = final: prev: let
    wrapper-manager = import sources.wrapper-manager;
    evald = wrapper-manager.lib {
      pkgs = prev;
      modules =
        builtins.readDir ../modules/wrapper-manager
        |> builtins.attrNames
        |> map (n: ../modules/wrapper-manager/${n});
    };
  in
    mapAttrs (_: value: value.wrapped) evald.config.wrappers;
in
  lib.composeManyExtensions [
    overlayAuto
    overlayMisc
    overlayWrapperManager
  ]
