{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "ccusage";
  version = "18.0.5";

  # Fetch the npm package directly
  src = fetchurl {
    url = "https://registry.npmjs.org/ccusage/-/ccusage-${version}.tgz";
    hash = "sha256-Co9+jFDk4WmefrDnJvladjjYk+XHhYYEKNKb9MbrkU8=";
  };

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/ccusage $out/bin

    # Extract and copy the npm package
    cp -r . $out/lib/node_modules/ccusage/

    # Create executable wrapper for the CLI
    makeWrapper ${nodejs}/bin/node $out/bin/ccusage \
      --add-flags "$out/lib/node_modules/ccusage/dist/index.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A CLI tool for analyzing Claude Code usage from local JSONL files";
    longDescription = ''
      ccusage is a command-line tool for analyzing Claude Code usage patterns
      by reading local JSONL files. It provides insights into token consumption,
      usage statistics, and helps track Claude Code API usage over time.
    '';
    homepage = "https://github.com/ryoppippi/ccusage";
    license = licenses.mit;
    maintainers = with maintainers; [polarmutex];
    mainProgram = "ccusage";
    platforms = platforms.unix;
  };
}
