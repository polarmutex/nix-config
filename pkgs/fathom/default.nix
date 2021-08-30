{ fetchurl, stdenv, lib, ... }:
stdenv.mkDerivation {
  pname = "fathom";
  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/usefathom/fathom/releases/download/v1.2.1/fathom_1.2.1_linux_amd64.tar.gz";
    sha256 = "0sfpxh2xrvz992k0ynib57zzpcr0ikga60552i14m13wppw836nh";
  };

  sourceRoot = ".";

  installPhase = ''
    install -m 755 -D fathom $out/bin/fathom
  '';

  meta = with lib; {
    homepage = "https://usefathom.com/";
    description = "Fathom";
    platforms = platforms.linux;
  };

}
