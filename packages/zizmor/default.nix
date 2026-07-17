{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-wiVAZ26JJB3C9WYiM5OfK83oT1HDr1jlfvcpELFHy0E=";
  };

  cargoHash = "sha256-Cbu0ur4WUURgrgITe5UCz5qTHR3F6PjxEqbm1t+lpBA=";

  doCheck = false;

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "Static analysis tool for GitHub Actions security";
    homepage = "https://github.com/zizmorcore/zizmor";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "zizmor";
    platforms = platforms.all;
  };
}
