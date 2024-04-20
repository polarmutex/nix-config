{
  pname,
  version,
  src,
  optimize ? true,
  #
  stdenv,
  pkgs,
  lib,
  #
  binaryen,
  makeRustPlatform,
  openssl,
  perl,
  pkg-config,
  protobuf,
  rust-bin,
}: let
  cargoTOML = builtins.fromTOML (builtins.readFile (src + "/Cargo.toml"));
  inherit (cargoTOML.package) name;
  cargoLock = {
    lockFile = builtins.path {
      path = src + "/Cargo.lock";
      name = "Cargo.lock";
    };
    allowBuiltinFetchGit = true;
  };

  rustToolchainTOML = rust-bin.fromRustupToolchainFile (src + /rust-toolchain.toml);
  rustWasmToolchainTOML = rustToolchainTOML.override {
    extensions = [];
    targets = ["wasm32-wasi"];
  };

  make-default-zellij-plugin = pname:
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

  compact-bar = make-default-zellij-plugin "compact-bar";
  session-manager = make-default-zellij-plugin "session-manager";
  status-bar = make-default-zellij-plugin "status-bar";
  strider = make-default-zellij-plugin "strider";
  tab-bar = make-default-zellij-plugin "tab-bar";
in
  (makeRustPlatform {
    cargo = rustToolchainTOML;
    rustc = rustToolchainTOML;
  })
  .buildRustPackage
  {
    inherit
      cargoLock
      name
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
    ];

    patchPhase = ''
      cp ${tab-bar}/bin/tab-bar.wasm zellij-utils/assets/plugins/tab-bar.wasm
      cp ${status-bar}/bin/status-bar.wasm zellij-utils/assets/plugins/status-bar.wasm
      cp ${strider}/bin/strider.wasm zellij-utils/assets/plugins/strider.wasm
      cp ${compact-bar}/bin/compact-bar.wasm zellij-utils/assets/plugins/compact-bar.wasm
      cp ${session-manager}/bin/session-manager.wasm zellij-utils/assets/plugins/session-manager.wasm
    '';

    meta = {
      description = "A terminal workspace with batteries included";
      homepage = "https://zellij.dev/";
      license = [lib.licenses.mit];
      mainProgram = "zellij";
    };
  }
