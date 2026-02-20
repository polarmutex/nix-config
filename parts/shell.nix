_: {
  perSystem = {pkgs, ...}: {
    devShells.default = with pkgs;
      mkShellNoCC {
        packages = [
          sops
          # age
          # deploy-rs
          # taplo
          # inxi
          # pciutils
          # nvtop
          # mesa-demos
          # nh
          # lm_sensors
          nix-update
          # inputs.bun2nix.packages.${pkgs.stdenv.hostPlatform.system}.default
          # neovim.devMode
        ];

        shellHook = ''
          ln -fs ${pkgs.luarc-json} .luarc.json
        '';
      };
  };
}
