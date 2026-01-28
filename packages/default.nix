{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    inputs',
    ...
  }: {
    _module.args.pkgs = let
      sources = import ../npins;
    in
      import sources.nixpkgs rec {
        localSystem = system;
        config = {
          allowInsecurePredicate = pkg: let
            pname = lib.getName pkg;
            byName = builtins.elem pname [
              "gradle"
              "nix"
            ];
          in
            if byName
            then lib.warn "Allowing insecure package: ${pname}" true
            else false;

          allowUnfreePredicate = pkg: lib.warn "Allowing unfree package: ${lib.getName pkg}" true;
        };
        overlays = [
          (import ./overlay.nix lib config inputs')
          inputs.gen-luarc.overlays.default
        ];
      };

    packages = with pkgs; {
      inherit _1password-cli;
      inherit _1password-gui;
      inherit blink-cmp;
      inherit brave;
      inherit ccusage;
      inherit claude-usage-monitor;
      inherit context7-mcp;
      inherit flippertools;
      inherit ghostty;
      inherit github-mcp;
      inherit mcp-nixos;
      inherit morgen;
      inherit neovim;
      inherit obsidian;
      inherit ollama;
      inherit ungoogled-chromium;
      inherit wezterm;
      inherit zed-editor;
    };
  };
  #             # All of the typical devcontainers to be used.
  #             devContainers-ubuntu = pkgs.dockerTools.buildLayeredImage {
  #               name = "dev-env";
  #               tag = "latest";
  #               fromImage = pkgs.dockerTools.pullImage {
  #                 imageName = "ubuntu";
  #                 finalImageTag = "22.04";
  #                 imageDigest = "sha256:899ec23064539c814a4dbbf98d4baf0e384e4394ebc8638bea7bbe4cb8ef4e12";
  #                 sha256 = "sha256-+xF/L3xa/nnjrD3qZOcBAxyxxxec2NOsfVUKwUYE57s=";
  #               };
  #               # config.Cmd = ["${rubyEnv}/bin/bundler"];
  #             };

  #             profile = inputs.flakey-profile.lib.mkProfile {
  #               inherit pkgs;
  #               # Specifies things to pin in the flake registry and in NIX_PATH.
  #               pinned = {nixpkgs = toString inputs.nixpkgs;};
  #               paths = with pkgs;
  #               with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; let
  #                 findWrapperPackage = packageAttr:
  #                 # NixGL has wrapper packages in different places depending on how you
  #                 # access it. We want HM configuration to be the same, regardless of how
  #                 # NixGL is imported.
  #                 #
  #                 # First, let's see if we have a flake.
  #                   if builtins.hasAttr pkgs.stdenv.hostPlatform.system inputs.nixgl.packages
  #                   then inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.${packageAttr}
  #                   else
  #                     # Next, let's see if we have a channel.
  #                     if builtins.hasAttr packageAttr inputs.nixgL.packages
  #                     then inputs.nixgl.packages.${packageAttr}
  #                     else
  #                       # Lastly, with channels, some wrappers are grouped under "auto".
  #                       if builtins.hasAttr "auto" inputs.nixgl.packages
  #                       then inputs.nixgl.packages.auto.${packageAttr}
  #                       else throw "Incompatible NixGL package layout";

  #                 getWrapperExe = vendor: let
  #                   glPackage = findWrapperPackage "nixGL${vendor}";
  #                   glExe = lib.getExe glPackage;
  #                   vulkanPackage = findWrapperPackage "nixVulkan${vendor}";
  #                   vulkanExe =
  #                     # if cfg.vulkan.enable
  #                     # then
  #                     lib.getExe vulkanPackage
  #                     # else ""
  #                     ;
  #                 in "${glExe} ${vulkanExe}";
  #                 makePackageWrapper = vendor: environment: pkg:
  #                   if builtins.isNull inputs.nixgl.packages
  #                   then pkg
  #                   else
  #                     # Wrap the package's binaries with nixGL, while preserving the rest of
  #                     # the outputs and derivation attributes.
  #                     (pkg.overrideAttrs (old: {
  #                       name = "nixGL-${pkg.name}";

  #                       # Make sure this is false for the wrapper derivation, so nix doesn't expect
  #                       # a new debug output to be produced. We won't be producing any debug info
  #                       # for the original package.
  #                       separateDebugInfo = false;
  #                       nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.makeWrapper];
  #                       buildCommand = let
  #                         # We need an intermediate wrapper package because makeWrapper
  #                         # requires a single executable as the wrapper.
  #                         combinedWrapperPkg = pkgs.writeShellScriptBin "nixGLCombinedWrapper-${vendor}" ''
  #                           exec ${getWrapperExe vendor} "$@"
  #                         '';
  #                       in ''
  #                         set -eo pipefail

  #                         ${
  #                           # Heavily inspired by https://stackoverflow.com/a/68523368/6259505
  #                           lib.concatStringsSep "\n" (
  #                             map (outputName: ''
  #                               echo "Copying output ${outputName}"
  #                               set -x
  #                               cp -rs --no-preserve=mode "${pkg.${outputName}}" "''$${outputName}"
  #                               set +x
  #                             '') (old.outputs or ["out"])
  #                           )
  #                         }

  #                         rm -rf $out/bin/*
  #                         shopt -s nullglob # Prevent loop from running if no files
  #                         for file in ${pkg.out}/bin/*; do
  #                           local prog="$(basename "$file")"
  #                           makeWrapper \
  #                             "${lib.getExe combinedWrapperPkg}" \
  #                             "$out/bin/$prog" \
  #                             --argv0 "$prog" \
  #                             --add-flags "$file" \
  #                             ${lib.concatStringsSep " " (
  #                           lib.attrsets.mapAttrsToList (var: val: "--set '${var}' '${val}'") environment
  #                         )}
  #                         done

  #                         # If .desktop files refer to the old package, replace the references
  #                         for dsk in "$out/share/applications"/*.desktop ; do
  #                           if ! grep -q "${pkg.out}" "$dsk"; then
  #                             continue
  #                           fi
  #                           src="$(readlink "$dsk")"
  #                           rm "$dsk"
  #                           sed "s|${pkg.out}|$out|g" "$src" > "$dsk"
  #                         done

  #                         shopt -u nullglob # Revert nullglob back to its normal default state
  #                       '';
  #                     }))
  #                     // {
  #                       # When the nixGL-wrapped package is given to a HM module, the module
  #                       # might want to override the package arguments, but our wrapper
  #                       # wouldn't know what to do with them. So, we rewrite the override
  #                       # function to instead forward the arguments to the package's own
  #                       # override function.
  #                       override = args: makePackageWrapper vendor environment (pkg.override args);
  #                     };
  #               in [
  #                 inputs.neovim-flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  #                 # (makePackageWrapper "Intel" {} (unstable.zed-editor.overrideAttrs {withGles = true;}))
  #                 (makePackageWrapper "Intel" {} unstable.zed-editor)
  #                 claude-code
  #                 ccusage
  #                 bmad-method
  #                 gemini-cli
  #                 pkgs.superclaude
  #                 unstable.lazygit
  #                 unstable.gh
  #                 unstable.glab
  #                 unstable.devpod
  #                 unstable.git
  #               ];
  #             };
  #           }
  #       );
}
