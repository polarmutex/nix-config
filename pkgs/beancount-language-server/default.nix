{ lib
, stdenv
, fetchurl
, makeWrapper
, pkgs
, rustPlatform
, nix
}:
rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.0.2";

  src = pkgs.fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    sha256 = "sha256-eojH/zjp8a8p1SKZMY5UrzxlI3XngGPIAofkWiOSIU0=";
  };

  cargoSha256 = "sha256-LUXrTaW6aY/OPPaWFC0ejaeienrvrgasNXjenQZFEb0=";

  checkInputs = lib.optional (!stdenv.isDarwin) nix;

  meta = with lib; {
    description = "A work-in-progress language server for beancount";
    license = licenses.mit;
  };

}
