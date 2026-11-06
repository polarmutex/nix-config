{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  chromium,
  writeShellScript,
  makeDesktopItem,
  copyDesktopItems,
}: let
  version = "4.1.3";

  morgenDeb = fetchurl {
    name = "morgen-${version}.deb";
    url = "https://dl.todesktop.com/210203cqcj00tw1/versions/${version}/linux/deb";
    hash = "sha256-+1BCeZIdVyjco5be8z3xDPSHyemd2CEUBJ43cSDu6xo=";
  };

  morgenScript = writeShellScript "morgen" ''
    exec ${chromium}/bin/chromium --app=https://web.morgen.so "$@"
  '';

  desktopItem = makeDesktopItem {
    name = "morgen";
    desktopName = "Morgen";
    comment = "All-in-one Calendars, Tasks and Scheduler";
    exec = "morgen %U";
    icon = "morgen";
    categories = ["Office" "Calendar"];
    startupWMClass = "web.morgen.so";
  };
in
  stdenv.mkDerivation {
    pname = "morgen";
    inherit version;

    dontUnpack = true;

    nativeBuildInputs = [
      dpkg
      makeWrapper
      copyDesktopItems
    ];

    desktopItems = [desktopItem];

    installPhase = ''
      runHook preInstall

      install -Dm755 ${morgenScript} $out/bin/morgen

      dpkg -x ${morgenDeb} $TMP/deb
      for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512 1024x1024; do
        src="$TMP/deb/usr/share/icons/hicolor/$size/apps/morgen.png"
        if [ -f "$src" ]; then
          install -Dm644 "$src" "$out/share/icons/hicolor/$size/apps/morgen.png"
        fi
      done

      runHook postInstall
    '';

    meta = {
      description = "All-in-one Calendars, Tasks and Scheduler (web wrapper)";
      homepage = "https://morgen.so/";
      mainProgram = "morgen";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [polarmutex];
      platforms = lib.platforms.linux;
    };
  }
