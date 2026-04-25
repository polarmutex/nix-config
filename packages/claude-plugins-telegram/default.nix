{
  stdenv,
  bun,
  bun2nix,
}: let
  sources = import ../../npins;
  src = "${sources.claude-plugins-official}/external_plugins/telegram";
in
  stdenv.mkDerivation {
    pname = "claude-plugins-telegram";
    version = "0.0.6";

    inherit src;

    nativeBuildInputs = [
      bun
      bun2nix.hook
    ];

    bunDeps = bun2nix.fetchBunDeps {
      bunNix = ./bun.nix;
    };

    dontUseBunBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  }
