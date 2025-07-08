{
  pkgs,
  lib,
  ...
}: let
  commonFlags = [
    "--enable-features=${
      lib.concatStringsSep "," [
        "WebUIDarkMode"
        # "WaylandTextInputV3"
      ]
    }"
    "--force-dark-mode"
  ];
in {
  wrappers = {
    google-chrome = {
      basePackage = pkgs.unstable.google-chrome;
      prependFlags = commonFlags;
    };

    ungoogled-chromium = {
      basePackage = pkgs.unstable.ungoogled-chromium;
      prependFlags =
        commonFlags
        ++ [
          "--enable-features=${
            lib.concatStringsSep "," [
              "ClearDataOnExit"
            ]
          }"
        ];
    };

    brave = {
      basePackage = pkgs.unstable.brave;
      prependFlags =
        commonFlags
        ++ [
          "--ozone-platform=wayland"
          # "--disable-gpu"
        ];
    };
  };
}
