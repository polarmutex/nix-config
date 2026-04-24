{
  lib,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  unstable,
}:
unstable.buildGoModule rec {
  pname = "tsm";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "adibhanna";
    repo = "tsm";
    rev = "v${version}";
    hash = "sha256-onrRS1dJVL9GHFJq1lYrjAc3+WCToNRh4MDIJd0d404=";
  };

  vendorHash = "sha256-bvt7VZjG6GXxONWTAWhcy/USMmU5Ydi4WPm44X02GQs=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [sqlite];

  # The ghostty terminal backend requires libghostty-vt built from a specific
  # ghostty commit. Patch the build tags so the stub backend is used instead,
  # while CGO remains enabled for go-sqlite3.
  postPatch = ''
    substituteInPlace internal/session/terminal_backend_ghostty.go \
      --replace-fail '//go:build cgo' '//go:build cgo && ghostty_vt'
    substituteInPlace internal/session/backend_name_ghostty.go \
      --replace-fail '//go:build cgo' '//go:build cgo && ghostty_vt'
    substituteInPlace internal/session/terminal_backend_stub.go \
      --replace-fail '//go:build !cgo' '//go:build !cgo || !ghostty_vt'
    substituteInPlace internal/session/backend_name_stub.go \
      --replace-fail '//go:build !cgo' '//go:build !cgo || !ghostty_vt'
  '';

  meta = with lib; {
    description = "Terminal session manager";
    homepage = "https://github.com/adibhanna/tsm";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "tsm";
    platforms = platforms.all;
  };
}
