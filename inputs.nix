# Flake-shaped inputs built from npins pins, loaded via flake-compat.
# Replaces the `inputs` block of flake.nix; consumers keep using
# `inputs.<name>.packages.${system}`, `inputs.<name>.nixosModules`, etc.
let
  sources = import ./npins;
  flake-compat = import sources.flake-compat;
  load = name: let
    s = sources.${name};
  in
    (flake-compat {
      src = {
        inherit (s) outPath;
        rev = s.revision;
        shortRev = builtins.substring 0 7 s.revision;
      };
    }).outputs
    # flake-compat omits this for lockless flakes (e.g. nixpkgs); flake-parts checks it.
    // {_type = "flake";};
  # Call a flake's outputs with `overrides` replacing some of its locked
  # inputs (flake-compat has no `follows`). Also works for flakes that ship
  # no flake.lock, as long as `overrides` supplies all their inputs.
  loadWith = name: overrides: let
    s = sources.${name};
    locked =
      if builtins.pathExists "${s}/flake.lock"
      then (load name).inputs
      else {};
    inputs = locked // overrides;
    self =
      (import "${s}/flake.nix").outputs (inputs // {inherit self;})
      // {
        inherit inputs;
        inherit (s) outPath;
        rev = s.revision;
        _type = "flake";
      };
  in
    self;
  nixpkgs = load "nixpkgs";
in
  {
    inherit nixpkgs;
    # No flake.lock upstream; it asks for nixos-unstable.
    claude-cowork-service = loadWith "claude-cowork-service" {
      nixpkgs = load "nixpkgs-unstable";
      flake-utils = null; # declared but unused
    };
    # These used `inputs.nixpkgs.follows = "nixpkgs"` in flake.nix.
    MorgenMCP = loadWith "MorgenMCP" {inherit nixpkgs;};
    bun2nix = loadWith "bun2nix" {inherit nixpkgs;};
  }
  // builtins.listToAttrs (map (name: {
      inherit name;
      value = load name;
    }) [
      "flake-parts"
      "hardware"
      "sops-nix"
      "noshell"
      "llm-agents"
      "hermes-agent"
      "flakey-profile"
      "monolisa-font-flake"
      "beancount-repo"
      "sparkyfitness"
      "website"
      "gen-luarc"
    ])
