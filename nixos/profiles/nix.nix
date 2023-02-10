{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  nix = {
    gc.automatic = true;
    settings = {
      #sandbox = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      allowed-users = ["*"];
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-stable.flake = inputs.nixpkgs-stable;
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixpkgs-stable=${inputs.nixpkgs-stable}"
      "home-manager=${inputs.home-manager}"
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    #min-free = 536870912
    #keep-outputs = true
    #keep-derivations = true
    #fallback = true
  };
}