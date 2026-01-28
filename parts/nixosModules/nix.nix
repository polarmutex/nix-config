{
  flake.nixosModules.nix = {pkgs, ...}: {
    nix = {
      settings = {
        allowed-users = ["*"];
        auto-optimise-store = true;
        accept-flake-config = true; # Trust extra-substituters from flakes
        experimental-features = ["nix-command" "flakes" "pipe-operators"];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://polarmutex.cachix.org"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
        ];
        # plugin-files = "${pkgs.unstable.nix-plugins}/lib/nix/plugins";
        # plugin-files = "${pkgs.unstable.nix-plugins.overrideAttrs (old: {
        #   patches = [./nix-plugins.patch];
        #   buildInputs = [pkgs.nixVersions.nix_2_28 pkgs.boost];
        # })}/lib/nix/plugins";
        # extra-builtins-file = [../../misc/extra-builtins.nix];
      };
      # nixPath = [
      #   "nixpkgs=${pkgs.path}"
      # ];
    };
  };
}
