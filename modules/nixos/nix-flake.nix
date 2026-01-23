{
  inputs,
  pkgs,
  ...
}: let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
  # nixpkgsStablePath = "${base}/nixpkgs_stable";
in {
  programs.command-not-found.dbPath = inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;

  nix = {
    extraOptions = ''
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      # nixpkgs-stable.flake = inputs.nixpkgs-stable;
    };
    nixPath = [
      "nixpkgs=${nixpkgsPath}"
      # "nixpkgs-stable=${nixpkgsStablePath}"
    ];
    settings = {
      allowed-users = ["*"];
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  systemd.tmpfiles.rules = [
    "L+ ${nixpkgsPath}     - - - - ${inputs.nixpkgs}"
    # "L+ ${nixpkgsStablePath} - - - - ${inputs.nixpkgs-stable}"
  ];
}
