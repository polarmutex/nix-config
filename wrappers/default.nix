{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: let
    wrapped = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        ./wezterm
      ];
      specialArgs = {
        inherit inputs inputs';
      };
    };
    all-packages = wrapped.config.build.packages;
    # eval = inputs.wrapper-manager.lib {
    #   inherit pkgs;
    #   modules = [
    #     #(import ./nvfetcher {inherit (inputs) nixpkgs;})
    #   ];
    # };
  in {
    packages = all-packages;
    # inherit (eval.config.build) packages;
    # checks = {
    #inherit (config.package) nvfetcher;
    # };
  };
}
