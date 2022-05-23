{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, pkg-config
, fontconfig
, python3
, openssl
, perl
, dbus
, libX11
, xcbutil
, libxcb
, xcbutilimage
, xcbutilkeysyms
, xcbutilwm # contains xcb-ewmh among others
, libxkbcommon
, libglvnd # libEGL.so.1
, egl-wayland
, wayland
, libGLU
, libGL
, freetype
, zlib
, inputs
}:
let
  runtimeDeps = [
    dbus
    egl-wayland
    fontconfig
    freetype
    libGL
    libGLU
    libglvnd
    libX11
    libxcb
    libxkbcommon
    openssl
    wayland
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilwm
    zlib
  ];

in
rustPlatform.buildRustPackage rec {
  pname = "wezterm-nightly";
  version = "master";

  src = inputs.wezterm-git-src;

  postPatch = ''
    echo ${version} > .tag
  '';

  cargoSha256 = "sha256-ouW9sycbZyfMHlrzp2Djt5DAY8PBU1U+YletEiOMZ34=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config python3 perl ];

  buildInputs = runtimeDeps;

  preFixup = lib.optionalString stdenv.isLinux ''
        for artifact in wezterm wezterm-gui wezterm-mux-server strip-ansi-escapes; do
          patchelf --set-rpath "${
    lib.makeLibraryPath runtimeDeps
    }" $out/bin/$artifact
        done
  '';

  # prevent further changes to the RPATH
  dontPatchELF = true;
  singleStep = true;

  gitAllRefs = true;
  gitSubmodules = true;

  meta = with lib; {
    description =
      "A GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust";
    homepage = "https://wezfurlong.org/wezterm";
    license = licenses.mit;
    maintainers = with maintainers; [ steveej SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
