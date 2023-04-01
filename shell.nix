{
  self,
  sops-nix,
  ...
}: system:
with self.legacyPackages.${system};
  mkShell
  {
    name = "nix-config";

    sopsPGPKeyDirs = [
      "${toString ./..}/secrets/keys/hosts"
      "${toString ./..}/secrets/keys/users"
    ];

    nativeBuildInputs = [
      # Nix
      #cachix
      deploy-rs.deploy-rs
      #nix-build-uncached
      #nix-linter
      #nixpkgs-fmt
      #ragenix
      #rnix-lsp
      sops
      (callPackage sops-nix {}).sops-import-keys-hook
      #statix
      home-manager

      # GitHub Actions
      #act
      #actionlint
      #python3Packages.pyflakes
      #shellcheck

      # Misc
      #jq
      #pre-commit
      #rage
    ];

    shellHook = ''
      ${self.checks.${system}.pre-commit-check.shellHook}
    '';
  }
