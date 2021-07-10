{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:nix-community/neovim-nightly-overlay";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, neovim-flake, ... }:
  let

    inherit (nixpkgs) lib;
    inherit (lib) attrValues;
    
    util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays);  };

    inherit (util) host;
    inherit (util) user;

    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [
        neovim-flake.overlay
      ];
    };


  in {

    homeManagerConfigurations = {
      brian = user.mkHomeManagerUser {
        roles = [
          "desktop/dwm"
          "git"
          "zsh"
          "neovim"
          "tmux"
          "obsidian"
          "anki"
          "1password"
        ];
        username = "brian";
      };
      work = user.mkHomeManagerUser {
        roles = [ "desktop/dwm" "neovim" "work" "git" "tmux"];
        username = "brian";
      };
    };

    nixosConfigurations = {
      nixos = host.mkHost {
        name = "nixos";
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
