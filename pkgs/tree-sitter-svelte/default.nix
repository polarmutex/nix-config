{ lib
, stdenv
, fetchurl
, makeWrapper
, pkgs
}:
stdenv.mkDerivation rec {
  pname = "svelte-grammer";
  version = "0.20";

  src = pkgs.fetchFromGitHub {
    owner = "Himujjal";
    repo = "tree-sitter-svelte";
    rev = "349a5984513b4a4a9e143a6e746120c6ff6cf6ed";
    sha256 = "sha256-1lTGto4YrVUiLpW9QocbBSLYW6llcX9bmQQLZga633s=";
  };
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev pkgs.libcxx}/include/c++/v1";
  buildInputs = [ pkgs.tree-sitter ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
      scanner_cc="$src/src/scanner.cc"
      if [ ! -f "$scanner_cc" ]; then
        scanner_cc=""
      fi
      scanner_c="$src/src/scanner.c"
      if [ ! -f "$scanner_c" ]; then
        scanner_c=""
      fi
      $CC -I$src/src/ -shared -o parser -Os $src/src/parser.c $scanner_cc $scanner_c -lstdc++
      runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    runHook postInstall
  '';
}
