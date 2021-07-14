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
          "qmk"
	  "zoom"
        ];
        username = "brian";
      };
      work = user.mkHomeManagerUser {
        roles = [
          "desktop/dwm"
          "neovim"
          "work"
          "git"
          "tmux"
          "zsh"
          "obsidian"
        ];
        username = "brian";
      };
    };

    nixosConfigurations = {
      nixos = host.mkHost {
        name = "nixos";
        NICs = [ "enp3s0" ];
        kernelPackage = pkgs.linuxPackages_5_11;
        initrdMods = [
          "xhci_pci"
          "ehci_pci"
          "ahci"
          "usbhid"
          "sd_mod"
          "sr_mod"
        ];
        kernelMods = [ "kvm-intel" "wl" ];
        kernelParams = [];
        roles = [ "efi" "core" "desktop-xorg" "ssh" "yubikey" ];
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
