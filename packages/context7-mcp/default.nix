{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "context7-mcp";
  version = "2.1.0-unstable-2025-01-09";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    rev = "8edda6b07000dfd8feb5d47bcac3ae82e429efaf";
    hash = "sha256-eSMh5fgtkTjRPbN7RZZu3tb3294qRLaJZIVwH1pn/iI=";
  };

  nativeBuildInputs = [ nodejs pnpm pnpmConfigHook makeWrapper ];

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = "sha256-lC4I6W0ZOY7NmQBgdNb1Q+e03waEjpoQnRU+UA8PsXQ=";
  };

  preConfigure = ''
    cd packages/mcp
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Copy the entire workspace to preserve pnpm symlink structure
    mkdir -p $out/lib
    cp -r ../../node_modules $out/lib/
    cp -r ../../packages $out/lib/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/context7-mcp \
      --add-flags "$out/lib/packages/mcp/dist/index.js" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = with lib; {
    description = "MCP server for Context7 - delivers up-to-date code documentation to LLMs";
    homepage = "https://github.com/upstash/context7";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "context7-mcp";
    platforms = platforms.all;
  };
}
