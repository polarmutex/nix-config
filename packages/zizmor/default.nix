{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "zizmor";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${version}";
    hash = "sha256-wBBMF6FNwzlJiVag5tE64YnDf5Se+J5kJ/beVfg9H/Q=";
  };

  cargoHash = "sha256-b7tcTvECEFb1fBVSo6y+NL4YognKuOBjAVMIyrCXZGQ=";

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
