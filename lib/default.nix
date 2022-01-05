# callPackage = lib.callPackageWith args;
#  fileList = callPackage ./file-list.nix { };
# inherit (fileList) getFileList getRecursiveNixFileList;

with builtins;
rec {
  defaultSystems = [
    "x86_64-linux"
  ];

  # Taken from flake-utils
  # List of all systems defined in nixpkgs
  # Keep in sync with nixpkgs wit the following command:
  # $ nix-instantiate --json --eval --expr "with import <nixpkgs> {}; lib.platforms.all" | jq
  allSystems = [
    "aarch64-linux"
    "armv5tel-linux"
    "armv6l-linux"
    "armv7a-linux"
    "armv7l-linux"
    "mipsel-linux"
    "i686-cygwin"
    "i686-freebsd"
    "i686-linux"
    "i686-netbsd"
    "i686-openbsd"
    "x86_64-cygwin"
    "x86_64-freebsd"
    "x86_64-linux"
    "x86_64-netbsd"
    "x86_64-openbsd"
    "x86_64-solaris"
    "x86_64-darwin"
    "i686-darwin"
    "aarch64-darwin"
    "armv7a-darwin"
    "x86_64-windows"
    "i686-windows"
    "wasm64-wasi"
    "wasm32-wasi"
    "x86_64-redox"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "arm-none"
    "armv6l-none"
    "aarch64-none"
    "avr-none"
    "i686-none"
    "x86_64-none"
    "powerpc-none"
    "msp430-none"
    "riscv64-none"
    "riscv32-none"
    "vc4-none"
    "js-ghcjs"
    "aarch64-genode"
    "x86_64-genode"
  ];

  evalMods = { allPkgs, systems ? defaultSystems, modules, args ? { } }: withSystems systems (sys:
    let
      pkgs = allPkgs."${sys}";
    in
    pkgs.lib.evalModules {
      inherit modules;
      specialArgs = { inherit pkgs; } // args;
    });

  mkPkgs = { nixpkgs, systems ? defaultSystems, cfg ? { }, overlays ? [ ] }: withSystems systems (sys:
    import nixpkgs {
      system = sys;
      config = cfg;
      overlays = map (m: m."${sys}") overlays;
    });

  mkOverlays = { allPkgs, systems ? defaultSystems, overlayFunc }: withSystems systems (sys:
    let pkgs = allPkgs."${sys}";
    in overlayFunc sys pkgs);

  withDefaultSystems = withSystems defaultSystems;
  withSystems = systems: f: foldl'
    (cur: nxt:
      let
        ret = {
          "${nxt}" = f nxt;
        };
      in
      cur // ret)
    { }
    systems;

  mkNixOS = { hostname, nixpkgs, allPkgs, system, ... }:
    let
      pkgs = allPkgs."${system}";
    in
    nixpkgs.lib.nixosSystem
      {
        inherit system;

        modules = [
          (./.. + "/hosts/${hostname}/configuration.nix")
          (./.. + "/hosts/${hostname}/hardware-configuration.nix")
          {
            custom.base.general.hostname = hostname;
            nixpkgs.pkgs = pkgs;
            #TODO system.configurationRevision = inputs.self.rev or "dirty";
          }
        ] ++ getFileList {
          recursive = true;
          isValidFile = nixpkgs.lib.hasSuffix ".nix";
          path = ../modules/nixos;
          inherit nixpkgs;
        };
      };

  mkHome = { username, system, hostname }:
    home-manager.lib.homeManagerConfiguration {
      inherit username pkgs system;
      configuration = "./hosts/${hostname}/home-${username}.nix";
      homeDirectory = "/home/${username}";
      stateVersion = "21.11";
      extraModules = homeModules;
    };

  getFileList = { recursive, isValidFile, path, nixpkgs }:
    let
      contents = readDir path;

      list = nixpkgs.lib.mapAttrsToList
        (name: type:
          let
            newPath = path + ("/" + name);
          in
          if type == "directory"
          then
            if recursive
            then
              getFileList
                {
                  recursive = true;
                  inherit isValidFile;
                  path = newPath;
                  inherit nixpkgs;
                }
            else [ ]
          else nixpkgs.lib.optional (isValidFile newPath) newPath
        )
        contents;
    in
    nixpkgs.lib.flatten list;

}
