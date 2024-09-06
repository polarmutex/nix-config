{
  lib,
  pkgs,
  ...
}: let
  themes = {
    aerial = {
      pkg = rec {
        name = "aerial";
        version = "20240615";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "${name}-sddm-theme";
          rev = "92b85ec7d177683f39a2beae40cde3ce9c2b74b0";
          sha256 = "sha256-0MdjhuftOrIDnqMvADPU9/55s/Upua9YpfIz0wpGg4E=";
        };
      };
      deps = with pkgs; [
        qt5.qtmultimedia
        qt5.qtgraphicaleffects
        qt5.qtquickcontrols2
        gst_all_1.gst-plugins-good
        libsForQt5.phonon-backend-gstreamer
        gst_all_1.gst-libav
      ];
    };
  };
  buildTheme = {
    name,
    version,
    src,
    themeIni ? [],
  }:
    pkgs.stdenv.mkDerivation rec {
      pname = "sddm-theme-${name}";
      inherit version src;

      buildCommand = ''
        dir=$out/share/sddm/themes/${name}
        doc=$out/share/doc/${pname}

        mkdir -p $dir $doc
        if [ -d $src/${name} ]; then
          srcDir=$src/${name}
        else
          srcDir=$src
        fi
        cp -r $srcDir/* $dir/
        for f in $dir/{AUTHORS,COPYING,LICENSE,README,*.md,*.txt}; do
          test -f $f && mv $f $doc/
        done
        chmod 777 $dir/theme.conf

        ${lib.concatMapStringsSep "\n" (e: ''
            ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf \
              "${e.section}" "${e.key}" "${e.value}"
          '')
          themeIni}
      '';
    };
  packages =
    if customTheme
    then [(buildTheme theme.pkg)] ++ theme.deps
    else [];
  theme = themes.aerial;
  customTheme = builtins.isAttrs theme;
  themeName =
    if customTheme
    then theme.pkg.name
    else theme;
in {
  environment.systemPackages = with pkgs; [
    (sddm-chili-theme.override {
      themeConfig = {
        background = ./landscape-yosemite-national-park-3840x2160_9545-mm-90.jpg;
        # ScreenWidth = 1920;
        # ScreenHeight = 1080;
        blur = false;
        # recursiveBlurLoops = 3;
        # recursiveBlurRadius = 5;
      };
    })
  ];
  services = {
    displayManager = {
      #autoLogin = {
      #  enable = true;
      #  user = "polar";
      #};
      # gdm = {
      #   enable = true;
      #   wayland = false;
      # };
      sddm = let
      in {
        enable = true;
        enableHidpi = true;
        theme = "chili";
      };
    };
  };
}
