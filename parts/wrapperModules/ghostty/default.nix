{
  flake.wrappers.ghostty-polar = {
    config,
    pkgs,
    lib,
    wlib,
    ...
  }: let
    inherit (lib) types;

    toGhosttyConf = lib.generators.toKeyValue {
      listsAsDuplicateKeys = true;
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = v:
          if builtins.isBool v
          then
            (
              if v
              then "true"
              else "false"
            )
          else if builtins.isString v
          then v
          else builtins.toString v;
      } " = ";
    };

    baseConfig = builtins.readFile ./config;
    settingsConfig = toGhosttyConf config.settings;

    # Combine base config from file with any additional settings
    configContent = baseConfig + (
      if config.settings != {}
      then "\n# Additional settings from module options\n" + settingsConfig
      else ""
    );
  in {
    imports = [wlib.modules.default];

    options = {
      settings = lib.mkOption {
        type = types.attrsOf (
          types.oneOf [
            types.bool
            types.int
            types.str
            (types.listOf types.str)
          ]
        );
        default = {};
        example = lib.literalExpression ''
          {
            theme = "catppuccin-mocha";
            font-family = "JetBrainsMono Nerd Font";
            font-size = 12;
            window-padding-x = 10;
            window-padding-y = 10;
          }
        '';
        description = ''
          Configuration options for Ghostty terminal.
          These will be appended to the base config file.
          See <https://ghostty.org/docs/config/reference> for available options.
        '';
      };
    };

    config = {
      drv.buildPhase = ''
        runHook preBuild
        cat > ${lib.escapeShellArg "${placeholder "out"}/${config.binName}-config"} <<'EOF'
        ${configContent}
        EOF
        runHook postBuild
      '';

      package = lib.mkDefault pkgs.unstable.ghostty;
      flagSeparator = "=";

      flags = {
        "--config-file" = {
          data = "${placeholder "out"}/${config.binName}-config";
          esc-fn = lib.escapeShellArg;
        };
      };
    };
  };
}
