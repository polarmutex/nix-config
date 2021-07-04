{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixos-stable.url = "nixpkgs/nixos-21.05";

    nixos.url = "nixpkgs/nixos-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-21.05";
    home-manager-stable.inputs.nixos.follows = "nixos-stable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixos.follows = "nixos";

    neovim-flake.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixos, home-manager, neovim-flake, ... }:
  let

    inherit (nixos) lib;
    inherit (lib) attrValues;
    
    util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays);  };

    inherit (util) host;
    inherit (util) user;

    system = "x86_64-linux";

    pkgs = import nixos {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [
        neovim-flake.overlay
      ];
    };


  in {

    homeManagerConfigurations = {
      brian = user.mkHomeManagerUser {
        roles = [ "desktop/dwm" "git" "zsh" "neovim" ];
        username = "brian";
      };
    };

    nixosConfigurations = {
      nixosvm = host.mkHost {
        name = "nixosvm";
        NICs = [ "enp0s3" ];
        kernelPackage = pkgs.linuxPackages_5_11;
        initrdMods = [];
        kernelMods = [];
        kernelParams = [];
        roles = [ "vm" "core" "desktop-xorg" "ssh"];
        cpuCores = 4;
        users = [ {
          name = "brian";
          groups = [ "wheel" "networkmanager"];
          uid = 1000;
          shell = pkgs.zsh;
        }];
      };
    };
  };
}
