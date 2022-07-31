{ self
, awesome-flake
, home-manager
, neovim-flake
, nixpkgs
, nur
, polar-nur
, sops-nix
, ...
}:
let
  #
  # OLD
  #
  getFileList = recursive: isValidFile: path:
    let
      contents = builtins.readDir path;

      list = nixpkgs.lib.mapAttrsToList
        (name: type:
          let
            newPath = path + ("/" + name);
          in
          if type == "directory"
          then
            if recursive
            then getFileList true isValidFile newPath
            else [ ]
          else nixpkgs.lib.optional (isValidFile newPath) newPath
        )
        contents;
    in
    nixpkgs.lib.flatten list;

  pkgs = system: import nixpkgs {
    inherit system;
    overlays = [
      nur.overlay
      polar-nur.overlays.default
      (final: _prev: {
        neovim-polar = neovim-flake.packages.${final.system}.default;
      })
      (import ../nix/overlays/node-ifd.nix)
      neovim-flake.overlay
      (import ../nix/overlays/monolisa-font.nix)
      (import ../nix/overlays/fathom.nix)
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-13.6.9"
      ];
    };
  };

  nixosModules = hostname: [
    sops-nix.nixosModules.sops
    nixpkgs.nixosModules.notDetected
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.polar = {
        imports = [
          { _module.args.inputs = self.inputs; }
          (./.. + "/hosts/${hostname}/hm.nix")
        ] ++ hmModules;
      };
    }
  ] ++ getFileList true (nixpkgs.lib.hasSuffix ".nix") ../modules/nixos;

  hmModules = [
    ../users/home.nix
    neovim-flake.home-managerModule
    awesome-flake.home-managerModule
  ];

  # function to create default system config
  mkNixOS = hostname: system:
    nixpkgs.lib.nixosSystem
      {
        inherit system;

        modules = [
          { _module.args.inputs = self.inputs; }
          (import (../hosts + "/${hostname}/configuration.nix"))
          {
            nixpkgs = {
              pkgs = pkgs "x86_64-linux";
              inherit ((pkgs system)) config;
            };
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix = {
              #TODO in base package = (pkgs "x86_64-linux").nixFlakes;
              nixPath =
                let path = toString ./.; in
                (nixpkgs.lib.mapAttrsToList (name: _v: "${name}=${self.inputs.${name}}") self.inputs) ++ [ "repl=${path}/repl.nix" ];
              registry =
                (nixpkgs.lib.mapAttrs'
                  (name: _v: nixpkgs.lib.nameValuePair name { flake = self.inputs.${name}; })
                  self.inputs) // { ${hostname}.flake = self; };
            };
          }
        ] ++ (nixosModules hostname);
      };
  #
  # NEW
  #
  hostPkgs = localSystem: {
    nixpkgs = {
      localSystem.system = localSystem;
      pkgs = self.pkgs.${localSystem};
    };
  };
  genConfiguration = hostname: localSystem:
    nixpkgs.lib.nixosSystem {
      system = localSystem;
      modules = [
        {
          _module.args.self = self;
          _module.args.inputs = self.inputs;
        }
        (../nixos + "/${hostname}/configuration.nix")
        (hostPkgs localSystem)
      ];
      #specialArgs = {
      #  impermanence = impermanence.nixosModules;
      #  nixos-hardware = nixos-hardware.nixosModules;
      #};
    };
in
{
  polarbear = mkNixOS "polarbear" "x86_64-linux";

  polarvortex = mkNixOS "polarvortex" "x86_64-linux";

  blackbear = genConfiguration "blackbear" "x86_64-linux";
}
