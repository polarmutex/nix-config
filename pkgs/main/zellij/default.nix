{
  pname,
  version,
  src,
  optimize ? true,
  #
  stdenv,
  pkgs,
  #
  binaryen,
  makeRustPlatform,
  openssl,
  perl,
  pkg-config,
  protobuf,
  rust-bin,
}: let
  rustToolchainTOML = rust-bin.fromRustupToolchainFile (src + /rust-toolchain.toml);
  rustWasmToolchainTOML = rustToolchainTOML.override {
    extensions = [];
    targets = ["wasm32-wasi"];
  };

  makeZellijPlugin = pname:
    (pkgs.makeRustPlatform {
      cargo = rustWasmToolchainTOML;
      rustc = rustWasmToolchainTOML;
    })
    .buildRustPackage {
      inherit
        cargoLock
        pname
        src
        stdenv
        version
        ;
      nativeBuildInputs = [
        binaryen
        protobuf
      ];
      buildPhase = ''
        cargo build --package ${pname} --release --target=wasm32-wasi
        mkdir -p $out/bin;
      '';
      installPhase =
        if optimize
        then ''
          wasm-opt \
          -Oz target/wasm32-wasi/release/${pname}.wasm \
          -o $out/bin/${pname}.wasm \
          --enable-bulk-memory
        ''
        else ''
          mv \
          target/wasm32-wasi/release/${pname}.wasm \
          $out/bin/${pname}.wasm
        '';
      doCheck = false;
    };

  compact-bar = makeZellijPlugin "compact-bar";
  session-manager = makeZellijPlugin "session-manager";
  status-bar = makeZellijPlugin "status-bar";
  strider = makeZellijPlugin "strider";
  tab-bar = makeZellijPlugin "tab-bar";

  cargoLock = {
    lockFile = builtins.path {
      path = src + "/Cargo.lock";
      name = "Cargo.lock";
    };
    allowBuiltinFetchGit = true;
  };
in
  (makeRustPlatform {
    cargo = rustToolchainTOML;
    rustc = rustToolchainTOML;
  })
  .buildRustPackage
  {
    inherit
      cargoLock
      pname
      src
      stdenv
      version
      ;

    nativeBuildInputs = [
      pkg-config
      protobuf
      perl
    ];

    buildInputs = [
      openssl
      protobuf
      perl
    ];

    patchPhase = ''
      cp ${tab-bar}/bin/tab-bar.wasm zellij-utils/assets/plugins/tab-bar.wasm
      cp ${status-bar}/bin/status-bar.wasm zellij-utils/assets/plugins/status-bar.wasm
      cp ${strider}/bin/strider.wasm zellij-utils/assets/plugins/strider.wasm
      cp ${compact-bar}/bin/compact-bar.wasm zellij-utils/assets/plugins/compact-bar.wasm
      cp ${session-manager}/bin/session-manager.wasm zellij-utils/assets/plugins/session-manager.wasm
    '';
  }
