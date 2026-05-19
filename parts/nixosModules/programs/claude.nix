{ config, ... }:
let
  flakeCfg = config;
in {
  flake.nixosModules.claude = {...}: {
    imports = [flakeCfg.flake.wrappers.claude-code-polar.install];
  };
}
