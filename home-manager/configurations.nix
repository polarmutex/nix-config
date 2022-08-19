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
  genConfiguration =
    { username
    , hostname ? null
    , system
    , features ? [ ]
    , config_file ? ./polar
    }: home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${system};
      extraSpecialArgs = {
        inherit hostname username features;
      };
      modules = attrValues (import ./modules) ++ [
        config_file
      ];
    };
in
{
  "polar@polarbear" = genConfiguration {
    username = "polar";
    hostname = "polarbear";
    system = "x86_64-linux";
    features = [
      "desktop"
      "desktop/awesome.nix"
      "desktop/obsidian.nix"
      "desktop/stacks-taskmang.nix"
      "dev"
      "trusted"
    ];
  };
  "work" = genConfiguration {
    username = "blueguardian";
    hostname = "";
    system = "x86_64-linux";
    features = [
      "trusted"
      "desktop"
    ];
    config_file = ./work;
  };
}
