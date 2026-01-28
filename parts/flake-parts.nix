{inputs, ...}: {
  imports = [
    # inputs.flake-parts.flakeModules.modules # currently unused
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrapperModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };

  config = {
    systems = [
      "aarch64-darwin"
      # "aarch64-linux"
      # "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
