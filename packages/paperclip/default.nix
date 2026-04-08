{
  lib,
  stdenv,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  makeWrapper,
}: let
  sources = import ../../npins;
in
  stdenv.mkDerivation rec {
    pname = "paperclip";
    version = sources.paperclip.version;

    src = sources.paperclip;

    pnpmDeps = fetchPnpmDeps {
      inherit pname version src;
      pnpm = pnpm_9;
      fetcherVersion = 3;
      hash = "sha256-T8dV2tI4m2e8EBicFc/bgI0zewU/RH7PbrxvdNkeeEw=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_9
      pnpmConfigHook
      makeWrapper
    ];

    buildPhase = ''
      runHook preBuild

      # The CLI bundles workspace packages (db, shared, adapter-utils, adapters)
      # which have their own npm dependencies. We need to symlink those missing
      # dependencies into cli/node_modules so they're resolvable at runtime.

      # Find the zod and postgres packages in the pnpm store
      ZOD_DIR=$(find node_modules/.pnpm -maxdepth 1 -name "zod@*" -type d | head -1)
      POSTGRES_DIR=$(find node_modules/.pnpm -maxdepth 1 -name "postgres@*" -type d | head -1)
      WS_DIR=$(find node_modules/.pnpm -maxdepth 1 -name "ws@*" -type d | head -1)

      # Create symlinks in cli/node_modules
      if [ -n "$ZOD_DIR" ]; then
        ln -sf "../../$ZOD_DIR/node_modules/zod" cli/node_modules/zod
      fi
      if [ -n "$POSTGRES_DIR" ]; then
        ln -sf "../../$POSTGRES_DIR/node_modules/postgres" cli/node_modules/postgres
      fi
      if [ -n "$WS_DIR" ]; then
        ln -sf "../../$WS_DIR/node_modules/ws" cli/node_modules/ws
      fi

      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,lib}

      # Copy the workspace structure to lib (keep all deps including transitive ones)
      cp -r cli $out/lib/
      cp -r server $out/lib/
      cp -r ui $out/lib/
      cp -r packages $out/lib/
      cp -r node_modules $out/lib/
      cp package.json $out/lib/

      # Remove source files from workspace packages only (not node_modules)
      rm -rf $out/lib/cli/src
      rm -rf $out/lib/server/src
      rm -rf $out/lib/ui/src
      find $out/lib/packages -type d -name src -exec rm -rf {} + 2>/dev/null || true

      # Patch package.json exports to point to dist JS files instead of src TS files
      for pkg in server ui packages/* packages/adapters/* packages/plugins/*; do
        if [ -f "$out/lib/$pkg/package.json" ]; then
          ${nodejs}/bin/node -e "
            const fs = require('fs');
            const path = '$out/lib/$pkg/package.json';
            const pkg = JSON.parse(fs.readFileSync(path, 'utf8'));
            if (pkg.exports) {
              // Handle both string and object exports
              for (const [key, value] of Object.entries(pkg.exports)) {
                if (typeof value === 'string' && value.includes('/src/')) {
                  // Replace /src/ with /dist/ and .ts with .js
                  pkg.exports[key] = value.replace('/src/', '/dist/').replace(/\.ts$/, '.js');
                }
              }
              fs.writeFileSync(path, JSON.stringify(pkg, null, 2));
            }
          "
        fi
      done

      # Create wrapper with working directory set to lib
      makeWrapper ${nodejs}/bin/node $out/bin/paperclip \
        --chdir "$out/lib" \
        --add-flags "$out/lib/cli/dist/index.js"

      runHook postInstall
    '';

    meta = with lib; {
      description = "CLI tool for paperclipai - AI-powered development assistant";
      homepage = "https://github.com/paperclipai/paperclip";
      license = licenses.mit;
      maintainers = [];
      mainProgram = "paperclip";
      platforms = platforms.all;
    };
  }
