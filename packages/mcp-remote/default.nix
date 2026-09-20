{
  lib,
  buildNpmPackage,
  fetchzip,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-remote";
  version = "0.14.2";

  src = fetchzip {
    url = "https://registry.npmjs.org/mcp-remote/-/mcp-remote-${finalAttrs.version}.tgz";
    hash = "sha256-giNdNDbzWXDF1q8kLy0CRl5AjXwMKqxOCjue4AdFTPE=";
  };

  # Upstream only publishes dist/ (prebuilt) + a package.json with no
  # lockfile and build-only devDependencies; swap in a trimmed package.json
  # (prod deps only) and a lockfile generated for it so npm can install just
  # the runtime dependencies.
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-E/wqv0WRqXEDBG9Exlmtea/EVRCMCXMUs6m6n08rkww=";

  npmFlags = ["--ignore-scripts"];

  dontNpmBuild = true;

  meta = {
    description = "Proxy bridging local stdio MCP clients to remote SSE/HTTP MCP servers";
    homepage = "https://github.com/punkpeye/mcp-remote";
    license = lib.licenses.mit;
    mainProgram = "mcp-remote";
    platforms = lib.platforms.all;
  };
})
