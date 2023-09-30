{inputs, ...}: let
  /*
  wrapperFor returns a wrapper w for a set of pkgs

  wrapper incudes automatic overrides for a callPackage definition
  */
  wrapperFor = _pkgs: _callPackage: path: extraOverrides: let
    # args :: set
    args = builtins.functionArgs (import path);

    usesNvfetcher = builtins.hasAttr "src" args || builtins.hasAttr "sources" args;

    sources = _pkgs.callPackages (path + "/generated.nix") {};

    firstSource = builtins.head (builtins.attrValues sources);

    nvfetcherOverrides =
      if ! usesNvfetcher
      then {}
      else if builtins.hasAttr "sources" args
      then {inherit sources;}
      else builtins.intersectAttrs args firstSource;
  in
    _callPackage path (nvfetcherOverrides // extraOverrides);
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    w = wrapperFor pkgs;
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (import inputs.rust-overlay)
      ];
    };

    legacyPackages = pkgs;

    packages = {
      my-zellij = w pkgs.callPackage ./main/zellij {};
    };
  };
}
