{ inputs }:

let
  homeModulesBuilder = { inputs, customLib, ... }:
    [
      {
        lib.custom = customLib;
      }
    ]
    ++ customLib.getRecursiveNixFileList (../modules/home-manager);

  wrapper = builder: system: name: args:
    let
      flakeArgs = { inherit inputs system; };
      perSystem = import ./per-system.nix flakeArgs;

      homeModules = homeModulesBuilder (flakeArgs // perSystem);

      builderArgs = flakeArgs // perSystem // { inherit args homeModules name; };
    in
    inputs.nixpkgs-stable.lib.nameValuePair name (import builder builderArgs);

  simpleWrapper = builder: system: name: wrapper builder system name { };
in

{
  mkHome = simpleWrapper ./builders/mkHome.nix;
  mkNixos = simpleWrapper ./builders/mkNixos.nix;
}
