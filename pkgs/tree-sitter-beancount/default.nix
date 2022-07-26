{ stdenv
, pkgs
}:
stdenv.mkDerivation rec {
  pname = "beancount-grammer";
  version = "0.19.5";

  src = pkgs.fetchFromGitHub {
    owner = "polarmutex";
    repo = "tree-sitter-beancount";
    rev = "518d02dcdae9425872147f596014f30b38d3fff5";
    sha256 = "sha256-lQkI2I6NHI3Vlxxqc8Gj4Vnark/Rln/LnN0ez0VBDEg";
  };
  #NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev pkgs.libcxx}/include/c++/v1";
  buildInputs = [ pkgs.tree-sitter ];

  dontUnpack = true;
  configurePhase = ":";
  buildPhase = ''
    runHook preBuild
    $CC -I$src/src/ -shared -o parser -Os $src/src/parser.c -lstdc++
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv parser $out/
    runHook postInstall
  '';
}
