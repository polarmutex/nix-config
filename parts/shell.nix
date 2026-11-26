_: {
  perSystem = {pkgs, ...}: {
    devShells.default = with pkgs;
      mkShellNoCC {
        packages = [
          nix-update
          sops
	  unstable.nixd
          # tigervnc
          # age
          # taplo
          # inxi
          # pciutils
          # nvtop
          # mesa-demos
          # nh
          # lm_sensors
          # inputs.bun2nix.packages.${pkgs.stdenv.hostPlatform.system}.default
          # neovim.devMode
        ];

        shellHook = ''
          ln -fs ${pkgs.luarc-json} .luarc.json
        '';
      };
  };
}
