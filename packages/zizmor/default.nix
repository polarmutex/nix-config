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

    cargoHash = "sha256-eNgq6B7aI90/hfBqieDbO7zV53PugyAUADxpqH4t4ek=";

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
