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
          "broadcom-sta-6.30.223.271-57-6.12.41"
          "libsoup-2.74.3"
        ];
        allowUnfreePredicate = pkg: let
          pname = lib.getName pkg;
          byName = builtins.elem pname [
            "1password"
            "1password-cli"
            "broadcom-sta"
            "claude-code"
            "corefonts"
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
            # cuda
            "cuda_cudart"
            "cuda_cccl"
            "cuda-merged"
            "cuda_cuobjdump"
            "cuda_gdb"
            "cuda_nvdisasm"
            "cuda_nvprune"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_nvml_dev"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "libcufft"
            "libcurand"
            "libcusolver"
            "libnvjitlink"
            "cuda_nvcc"
            "libcusparse"
            "libnpp"
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
          inputs.zed.overlays.default
          (
            _final: prev: {
              unstable = import inputs.nixpkgs {
                inherit (prev) system;
                inherit config;
              };
              umami = self'.packages.umami;
              claude-usage-monitor = self'.packages.claude-usage-monitor;
              ccusage = self'.packages.ccusage;
              bmad-method = self'.packages.bmad-method;
              superclaude = self'.packages.superclaude;
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
              bmad-method = callPackage ./bmad-method.nix {};
              superclaude = callPackage ./superclaude.nix {};

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
              profile = inputs.flakey-profile.lib.mkProfile {
                inherit pkgs;
                # Specifies things to pin in the flake registry and in NIX_PATH.
                pinned = {nixpkgs = toString inputs.nixpkgs;};
                paths = with pkgs; let
                  findWrapperPackage = packageAttr:
                  # NixGL has wrapper packages in different places depending on how you
                  # access it. We want HM configuration to be the same, regardless of how
                  # NixGL is imported.
                  #
                  # First, let's see if we have a flake.
                    if builtins.hasAttr pkgs.stdenv.hostPlatform.system inputs.nixgl.packages
                    then inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.${packageAttr}
                    else
                      # Next, let's see if we have a channel.
                      if builtins.hasAttr packageAttr inputs.nixgL.packages
                      then inputs.nixgl.packages.${packageAttr}
                      else
                        # Lastly, with channels, some wrappers are grouped under "auto".
                        if builtins.hasAttr "auto" inputs.nixgl.packages
                        then inputs.nixgl.packages.auto.${packageAttr}
                        else throw "Incompatible NixGL package layout";

                  getWrapperExe = vendor: let
                    glPackage = findWrapperPackage "nixGL${vendor}";
                    glExe = lib.getExe glPackage;
                    vulkanPackage = findWrapperPackage "nixVulkan${vendor}";
                    vulkanExe =
                      # if cfg.vulkan.enable
                      # then
                      lib.getExe vulkanPackage
                      # else ""
                      ;
                  in "${glExe} ${vulkanExe}";
                  makePackageWrapper = vendor: environment: pkg:
                    if builtins.isNull inputs.nixgl.packages
                    then pkg
                    else
                      # Wrap the package's binaries with nixGL, while preserving the rest of
                      # the outputs and derivation attributes.
                      (pkg.overrideAttrs (old: {
                        name = "nixGL-${pkg.name}";

                        # Make sure this is false for the wrapper derivation, so nix doesn't expect
                        # a new debug output to be produced. We won't be producing any debug info
                        # for the original package.
                        separateDebugInfo = false;
                        nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.makeWrapper];
                        buildCommand = let
                          # We need an intermediate wrapper package because makeWrapper
                          # requires a single executable as the wrapper.
                          combinedWrapperPkg = pkgs.writeShellScriptBin "nixGLCombinedWrapper-${vendor}" ''
                            exec ${getWrapperExe vendor} "$@"
                          '';
                        in ''
                          set -eo pipefail

                          ${
                            # Heavily inspired by https://stackoverflow.com/a/68523368/6259505
                            lib.concatStringsSep "\n" (
                              map (outputName: ''
                                echo "Copying output ${outputName}"
                                set -x
                                cp -rs --no-preserve=mode "${pkg.${outputName}}" "''$${outputName}"
                                set +x
                              '') (old.outputs or ["out"])
                            )
                          }

                          rm -rf $out/bin/*
                          shopt -s nullglob # Prevent loop from running if no files
                          for file in ${pkg.out}/bin/*; do
                            local prog="$(basename "$file")"
                            makeWrapper \
                              "${lib.getExe combinedWrapperPkg}" \
                              "$out/bin/$prog" \
                              --argv0 "$prog" \
                              --add-flags "$file" \
                              ${lib.concatStringsSep " " (
                            lib.attrsets.mapAttrsToList (var: val: "--set '${var}' '${val}'") environment
                          )}
                          done

                          # If .desktop files refer to the old package, replace the references
                          for dsk in "$out/share/applications"/*.desktop ; do
                            if ! grep -q "${pkg.out}" "$dsk"; then
                              continue
                            fi
                            src="$(readlink "$dsk")"
                            rm "$dsk"
                            sed "s|${pkg.out}|$out|g" "$src" > "$dsk"
                          done

                          shopt -u nullglob # Revert nullglob back to its normal default state
                        '';
                      }))
                      // {
                        # When the nixGL-wrapped package is given to a HM module, the module
                        # might want to override the package arguments, but our wrapper
                        # wouldn't know what to do with them. So, we rewrite the override
                        # function to instead forward the arguments to the package's own
                        # override function.
                        override = args: makePackageWrapper vendor environment (pkg.override args);
                      };
                in [
                  inputs.neovim-flake.packages.${system}.neovim
                  (makePackageWrapper "Intel" {} (unstable.zed-editor.overrideAttrs {withGles = true;}))
                  # (unstable.zed-editor.overrideAttrs
                  #   {withGles = true;})
                  unstable.claude-code
                  unstable.lazygit
                  unstable.gh
                  unstable.glab
                  unstable.devpod
                  unstable.git
                  bmad-method
                ];
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
