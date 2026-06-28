{
  lib,
  python312Packages,
  makeWrapper,
  whisper-cpp,
  cudaSupport ? false,
  cudaPackages ? null,
  ffmpeg,
  ydotool,
  libnotify,
  gtk4,
  gobject-introspection,
}: let
  sources = import ../../npins;
  whisper-cpp' =
    if cudaSupport
    then whisper-cpp.override {inherit cudaSupport cudaPackages;}
    else whisper-cpp;
in
  python312Packages.buildPythonApplication {
    pname = "whisper-dictation";
    version = "unstable-${lib.substring 0 8 sources.whisper-dictation.revision}";

    src = sources.whisper-dictation;

    pyproject = true;

    build-system = with python312Packages; [setuptools];

    dependencies = with python312Packages; [
      evdev
      pygobject3
      pyaudio
      pyyaml
    ];

    nativeBuildInputs = [makeWrapper gobject-introspection];

    buildInputs = [gtk4];

    postInstall = ''
      wrapProgram $out/bin/whisper-dictation \
        --prefix PATH : ${lib.makeBinPath [whisper-cpp' ffmpeg ydotool libnotify]} \
        --prefix GI_TYPELIB_PATH : "${gtk4}/lib/girepository-1.0:${gobject-introspection}/lib/girepository-1.0"
    '';

    meta = with lib; {
      description = "Privacy-first local speech-to-text dictation for NixOS";
      homepage = "https://github.com/jacopone/whisper-dictation";
      license = licenses.mit;
      maintainers = with maintainers; [polarmutex];
      mainProgram = "whisper-dictation";
      platforms = platforms.linux;
    };
  }
