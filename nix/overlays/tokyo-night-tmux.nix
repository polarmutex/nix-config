final: prev:
let
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}/${rtpFilePath}"; } // {
      overrideAttrs = f: mkTmuxPlugin (attrs // f attrs);
    };

  mkTmuxPlugin =
    a@{ pluginName
    , rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux"
    , namePrefix ? "tmuxplugin-"
    , src
    , unpackPhase ? ""
    , configurePhase ? ":"
    , buildPhase ? ":"
    , addonInfo ? null
    , preInstall ? ""
    , postInstall ? ""
    , path ? prev.lib.getName pluginName
    , ...
    }:
    if prev.lib.hasAttr "dependencies" a then
      throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (prev.stdenv.mkDerivation (a // {
        pname = namePrefix + pluginName;

        inherit pluginName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

        installPhase = ''
          runHook preInstall
          target=$out/${rtpPath}/${path}
          mkdir -p $out/${rtpPath}
          cp -r . $target
          if [ -n "$addonInfo" ]; then
            echo "$addonInfo" > $target/addon-info.json
          fi
          runHook postInstall
        '';
      }));
in
{
  myTmuxPlugins = {
    tokoyo-night-tmux = mkTmuxPlugin {
      pluginName = "tokyo-night-tmux";
      rtpFilePath = "tokyo-night.tmux";
      version = "master";
      src = prev.fetchFromGitHub {
        owner = "janoamaral";
        repo = "tokyo-night-tmux";
        rev = "master";
        sha256 = "sha256-Ih6tDQ8yVzaXCvYrL0PHCRSvmfW2sBu6AEAZrOrEXRQ=";
      };
    };
  };
}
