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

      util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays); };

      inherit (util) host;
      inherit (util) user;

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          neovim-flake.overlay
          (
            final: prev: {
              my = import ./pkgs { inherit pkgs; };
            }
          )
        ];
      };


    in
      {

        homeManagerConfigurations = {
          brian = user.mkHomeManagerUser {
            roles = [
              "desktop/dwm"
              "fonts"
              "git"
              "gpg"
              "zsh"
              "neovim"
              "tmux"
              "obsidian"
              "anki"
              "1password"
              "qmk"
              "zoom"
              "applications"
            ];
            username = "brian";
          };
          work = user.mkHomeManagerUser {
            roles = [
              "desktop/dwm"
              "fonts"
              "neovim"
              "work"
              "git"
              "tmux"
              "zsh"
              "obsidian"
              "gpg"
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
            roles = [ "efi" "core" "desktop-xorg" "ssh" "yubikey" "bluetooth" "kvm" ];
            cpuCores = 4;
            users = [
              {
                name = "brian";
                groups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
                uid = 1000;
                shell = pkgs.zsh;
              }
            ];
          };
        };
      };
}
