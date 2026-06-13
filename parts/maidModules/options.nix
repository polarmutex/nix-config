{ lib, ... }: {
  options.flake.maidModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
  };
}
