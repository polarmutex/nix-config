{
  lib,
  rustPlatform,
}: let
  sources = import ../../npins;
in
  rustPlatform.buildRustPackage {
    pname = "zizmor";
    version = lib.removePrefix "v" sources.zizmor.version;

    src = sources.zizmor;

    cargoHash = "sha256-3ALVZJNpk0HiwmDGQigoSXuOdJR94nEKOWWiP5aggxo=";

    doCheck = false;

    meta = with lib; {
      description = "Static analysis tool for GitHub Actions security";
      homepage = "https://github.com/zizmorcore/zizmor";
      license = licenses.mit;
      maintainers = with maintainers; [polarmutex];
      mainProgram = "zizmor";
      platforms = platforms.all;
    };
  }
