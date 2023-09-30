{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    eval = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        #(import ./nvfetcher {inherit (inputs) nixpkgs;})
      ];
    };
  in {
    inherit (eval.config.build) packages;
    checks = {
      #inherit (config.package) nvfetcher;
    };
  };
}
