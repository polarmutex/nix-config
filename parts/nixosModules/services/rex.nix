# Rex terminal multiplexer server: https://www.superlogical.com/rex/docs/linux/installation#nix-and-nixos
{
  flake.nixosModules.rex = let
    sources = import ../../../npins;
    # The rex flake's only input is nixpkgs; feed it our unstable pin.
    nixpkgs = {
      outPath = sources.nixpkgs-unstable;
      lib = import "${sources.nixpkgs-unstable}/lib";
    };
    rex = let
      self = (import "${sources.rex}/flake.nix").outputs {inherit self nixpkgs;};
    in
      self;
  in {
    imports = [rex.nixosModules.default];
    # Shared server as the `rex` user on /run/rex/server.sock; members of the `rex` group can connect.
    services.rex.enable = true;
  };
}
