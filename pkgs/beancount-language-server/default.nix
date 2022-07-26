{ lib
, stdenv
, pkgs
, rustPlatform
, nix
}:
rustPlatform.buildRustPackage rec {
  pname = "beancount-language-server";
  version = "1.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "polarmutex";
    repo = "beancount-language-server";
    rev = "v${version}";
    sha256 = "sha256-CkwNxamkErRo3svJNth2F8NSqlJNX+1S/srKu6Z+mX4=";
  };

  cargoSha256 = "sha256-NTUs9ADTn+KoE08FikRHrdptZkrUqnjVIlcr8RtDvic=";

  checkInputs = lib.optional (!stdenv.isDarwin) nix;

  meta = with lib; {
    description = "A work-in-progress language server for beancount";
    license = licenses.mit;
  };

}
