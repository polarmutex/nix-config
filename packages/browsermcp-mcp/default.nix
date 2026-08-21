{
  lib,
  buildNpmPackage,
  fetchzip,
  jq,
  makeWrapper,
  lsof,
  findutils,
}:
buildNpmPackage (finalAttrs: {
  pname = "browsermcp-mcp";
  version = "0.1.3";

  src = fetchzip {
    url = "https://registry.npmjs.org/@browsermcp/mcp/-/mcp-${finalAttrs.version}.tgz";
    hash = "sha256-NHFknZ2a7dKKcmLikFD6J1cjG/D4a1LBNr9xCYRpFF8=";
  };

  nativeBuildInputs = [jq makeWrapper];

  # Upstream package.json carries monorepo-only `workspace:*` devDependencies
  # that npm can't resolve outside that repo; they're unused since dontNpmBuild
  # skips the build step, so drop them before npm reads package.json.
  postPatch = ''
    jq 'del(.devDependencies)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-w5Z0mkt5Mp+9meTvgS/fI/PMvq9VfkB9j5P0jmoQM40=";

  npmFlags = ["--ignore-scripts"];

  dontNpmBuild = true;

  # Upstream shells out to `lsof`/`xargs` on startup to clear its websocket
  # port (dist/index.js killProcessOnPort); without them on PATH the process
  # hangs instead of completing the MCP stdio handshake, and Claude Code just
  # times out waiting for a response.
  postFixup = ''
    wrapProgram $out/bin/mcp-server-browsermcp \
      --prefix PATH : ${lib.makeBinPath [lsof findutils]}
  '';

  meta = {
    description = "MCP server for browser automation using Browser MCP";
    homepage = "https://browsermcp.io";
    license = lib.licenses.mit;
    mainProgram = "mcp-server-browsermcp";
    platforms = lib.platforms.all;
  };
})
