{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = [
      "https://polarmutex.cachix.org"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://zed.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    # allow-import-from-derivation = "true";
  };

  # All inputs are pinned with npins; see ./inputs.nix.
  outputs = {self, ...}: let
    pinned = import ./inputs.nix;
    # flake-parts derives `inputs'` from `self.inputs`, so expose the pins there too.
    inputs = pinned // {self = self // {inputs = pinned;};};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (
      {
        # lib,
        config,
        self,
        ...
      }: {
        imports = let
          sources = import ./npins;
          import-tree = import sources.import-tree;
          wrappers = import sources.nix-wrapper-modules {};
        in [
          ./packages
          (import-tree ./parts)
          wrappers.flakeModules.wrappers
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      }
    );
}
