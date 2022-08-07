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
inherit (builtins) elemAt match any mapAttrs attrValues attrNames listToAttrs;
  hostPkgs = localSystem: {
    nixpkgs = {
      localSystem.system = localSystem;
      pkgs = self.pkgs.${localSystem};
    };
  };
  genConfiguration = {
    username
    , hostname ? null
    , system
    , features ? []
    , config_file
    }: home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${system}.unstable;
      extraSpecialArgs = {
        inherit hostname username features;
      };
      modules = attrValues (import ./modules) ++ [
      ./${username}
      awesome-flake.home-managerModule
      ];
    };
in
{
  "polar@polarbear" = genConfiguration {
    username = "polar";
    hostname = "polarbear";
    system = "x86_64-linux";
    features = [
    "trusted"
    "desktop/wezterm.nix"
    ];
    config_file = ../nixos/polarbear/home-manager.nix;
  };
}
