{
  stdenv,
  lib,
}: let
  sources = import ../../npins;
in
  stdenv.mkDerivation {
    pname = "mattpocock-skills";
    version = sources.mattpocock-skills.revision;

    src = sources.mattpocock-skills;

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';

    meta = {
      description = "Skills for Real Engineers - Claude Code skills from mattpocock";
      homepage = "https://github.com/mattpocock/skills";
      license = lib.licenses.mit;
    };
  }
