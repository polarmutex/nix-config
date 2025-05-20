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
      flags = commonFlags;
    };

    ungoogled-chromium = {
      basePackage = pkgs.unstable.ungoogled-chromium;
      flags =
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
      flags =
        commonFlags
        ++ [
          # "--ozone-platform=wayland"
          "--disable-gpu"
        ];
    };
  };
}
