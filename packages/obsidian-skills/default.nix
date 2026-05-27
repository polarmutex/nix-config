{
  stdenv,
  lib,
}: let
  sources = import ../../npins;
in
  stdenv.mkDerivation {
    pname = "obsidian-skills";
    version = sources.obsidian-skills.revision;

    src = sources.obsidian-skills;

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';

    meta = {
      description = "Claude Code skills for Obsidian workflows";
      homepage = "https://github.com/kepano/obsidian-skills";
      license = lib.licenses.mit;
    };
  }
