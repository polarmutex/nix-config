flake @ {
  lib,
  config,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    inputs',
    self',
    ...
  }: {
    _module.args = let
      config = {
        permittedInsecurePackages = [
          "electron-32.3.3"
        ];
        allowUnfreePredicate = pkg: let
          pname = lib.getName pkg;
          byName = builtins.elem pname [
            "1password"
            "1password-cli"
            "broadcom-sta"
            "claude-code"
            "corefonts"
            "cuda_cudart"
            "cuda_cccl"
            "cuda_nvcc"
            "discord"
            "google-chrome"
            "libcublas"
            "prismlauncher"
            "morgen"
            "nvidia-x11"
            "nvidia-settings"
            "nvidia-persistenced"
            "obsidian"
            "open-webui"
            "steam"
            "steam-original"
            "symbola"
            "vagrant"
            "vmware-workstation"
            "zoom"
            # "google-chrome"
          ];
          byLicense = builtins.elem pkg.meta.license.shortName [
            # "CUDA EULA"
            # "bsl11"
          ];
        in
          if byName || byLicense
          then lib.warn "Allowing unfree package: ${pname}" true
          else false;
      };
    in {
      # pkgs = import inputs.nixpkgs {
      #   inherit config system;
      #   overlays = [
      #     (import inputs.rust-overlay)
      #     (_final: prev: {
      #       # unstable-small = import inputs.nixpkgs-small {
      #       #   inherit (prev) system;
      #       #   inherit config;
      #       # };
      #     })
      #   ];
      # };
      pkgs = import inputs.nixpkgs-stable {
        inherit config system;
        overlays = [
          (
            _final: prev: {
              unstable = import inputs.nixpkgs {
                inherit (prev) system;
                inherit config;
              };
              umami = self'.packages.umami;
              claude-usage-monitor = self'.packages.claude-usage-monitor;
              ccusage = self'.packages.ccusage;
              polarmutex-website = inputs'.website.packages.default;
              # why was this here?
              # gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
              #   configureFlags =
              #     (lib.remove "--enable-ssh-agent" old.configureFlags)
              #     ++ [
              #       "--disable-ssh-agent"
              #     ];
              # });
            }
          )
        ];
      };
    };

    packages = lib.fix (
      self: let
        # packages in $FLAKE/packages, callPackage'd automatically
        stage1 = lib.fix (
          self': let
            callPackage = lib.callPackageWith (pkgs // self');

            auto = lib.pipe (builtins.readDir ./.) [
              (lib.filterAttrs (_name: value: value == "directory"))
              (builtins.mapAttrs (name: _: callPackage ./${name} {}))
            ];
          in
            auto
            // {
              # nix = pkgs.nix;
              # nil = inputs'.nil.packages.default;
              # manual overrides to auto callPackage
              # nix-index = callPackage ./nix-index {
              #   database = inputs'.nix-index-database.packages.nix-index-database;
              #   databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
              # };
              umami = callPackage ./umami {};
              claude-usage-monitor = callPackage ./claude-usage-monitor.nix {};
              ccusage = callPackage ./ccusage.nix {};

              # All of the typical devcontainers to be used.
              devContainers-ubuntu = pkgs.dockerTools.buildLayeredImage {
                name = "dev-env";
                tag = "latest";
                fromImage = pkgs.dockerTools.pullImage {
                  imageName = "ubuntu";
                  finalImageTag = "22.04";
                  imageDigest = "sha256:899ec23064539c814a4dbbf98d4baf0e384e4394ebc8638bea7bbe4cb8ef4e12";
                  sha256 = "sha256-+xF/L3xa/nnjrD3qZOcBAxyxxxec2NOsfVUKwUYE57s=";
                };
                # config.Cmd = ["${rubyEnv}/bin/bundler"];
              };
            }
        );

        # wrapper-manager packages
        stage2 =
          stage1
          // (inputs.wrapper-manager.lib {
            pkgs = pkgs // stage1;
            modules = lib.pipe (builtins.readDir ../modules/wrapper-manager) [
              (lib.filterAttrs (_name: value: value == "directory"))
              builtins.attrNames
              (map (n: ../modules/wrapper-manager/${n}))
            ];
            specialArgs = {
              inherit inputs';
            };
          }).config.build.packages;

        # packages that depend of wrappers
        stage3 = let
          p = pkgs // self;
          callPackage = lib.callPackageWith p;
        in
          stage2
          // {
            # env = callPackage ./env {
            #   inherit inputs';
            # };
            # maid = inputs.nix-maid p ../modules/maid;
          };
      in
        stage3
    );

    checks = {};
  };
}
