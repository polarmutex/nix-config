{ self
, pre-commit-hooks
, ...
}:

system:

with self.pkgs.${system};

{
  pre-commit-check = pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource ../.;
      hooks = {
        #nix-linter.enable = true;
        #nixpkgs-fmt.enable = true;
        #statix.enable = true;
        #stylua = {
        #  enable = true;
        #  types = [ "file" "lua" ];
        #  entry = "${stylua}/bin/stylua";
        #};
        #luacheck = {
        #  enable = true;
        #  types = [ "file" "lua" ];
        #  entry = "${luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
        #};
        actionlint = {
          enable = true;
          files = "^.github/workflows/";
          types = [ "yaml" ];
          entry = "${actionlint}/bin/actionlint";
        };
      };
      settings.nix-linter.checks = [
        "DIYInherit"
        "EmptyInherit"
        "EmptyLet"
        "EtaReduce"
        "LetInInheritRecset"
        "ListLiteralConcat"
        "NegateAtom"
        "SequentialLet"
        "SetLiteralUpdate"
        "UnfortunateArgName"
        "UnneededRec"
        "UnusedArg"
        "UnusedLetBind"
        "UpdateEmptySet"
        "BetaReduction"
        "EmptyVariadicParamSet"
        "UnneededAntiquote"
        "no-FreeLetInFunc"
        "no-AlphabeticalArgs"
        "no-AlphabeticalBindings"
      ];
    };
  #statix = pkgs.runCommand "statix" { } ''
  #  ${pkgs.statix}/bin/statix check ${./.} --format errfmt | tee output
  #  [[ "$(cat output)" == "" ]];
  #  touch $out
  #'';
  #nixpkgs-fmt = pkgs.runCommand "nixpkgs-fmt" { } ''
  #  shopt -s globstar
  #  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}/**/*.nix
  #  touch $out
  #'';
} // (deploy-rs.lib.deployChecks self.deploy)
