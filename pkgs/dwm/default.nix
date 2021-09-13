{ lib, stdenv, fetchgit, libX11, libXinerama, libXft }:
stdenv.mkDerivation rec {
  pname = "dwm";
  version = "6.2-polar";

  src = fetchgit (builtins.fromJSON (builtins.readFile ./source.json));

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  buildPhase = " make ";
}
