{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "zizmor";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-AL4y9lB60zvWhr5U6vzVyg0DhxFCaKkP8+6DWdg2vYA=";
  };

  cargoHash = "sha256-PGU9R6EKT+9ZdgxBgQqlvvmyEtDRG6zT2EdQPzlPIM0=";

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
