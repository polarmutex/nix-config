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
      basePackage = pkgs.google-chrome;
      flags = commonFlags;
    };

    ungoogled-chromium = {
      basePackage = pkgs.ungoogled-chromium;
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
      basePackage = pkgs.brave;
      flags = commonFlags;
    };
  };
}
