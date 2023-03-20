{
  programsdb,
  nixpkgs,
  nixpkgs-stable,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
  nixpkgsStablePath = "${base}/nixpkgs_stable";
in {
  options.nix.flakes.enable = lib.mkEnableOption "nix flakes";

  config = lib.mkIf config.nix.flakes.enable {
    programs.command-not-found.dbPath = programsdb.packages.${pkgs.system}.programs-sqlite;

    nix = {
      extraOptions = ''
        warn-dirty = false
      '';
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      registry = {
        nixpkgs.flake = nixpkgs;
        nixpkgs-stable.flake = nixpkgs-stable;
      };
      nixPath = [
        "nixpkgs=${nixpkgsPath}"
        "nixpkgs-stable=${nixpkgsStablePath}"
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
      "L+ ${nixpkgsPath}     - - - - ${nixpkgs}"
      "L+ ${nixpkgsStablePath} - - - - ${nixpkgs-stable}"
    ];
  };
}
