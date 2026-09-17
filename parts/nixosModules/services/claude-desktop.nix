{ inputs, ... }: {
  flake.nixosModules.claude-desktop = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.claude-cowork-service.nixosModules.default];

    options.services.claude-desktop = {
      claudeCodePackage = lib.mkOption {
        type = lib.types.package;
        description = "The claude-code package added to the cowork service PATH.";
      };
    };

    config = let
      cfg = config.services.claude-desktop;
    in {
      environment.systemPackages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
      ];

      services.claude-cowork = {
        enable = true;
        extraPath = [cfg.claudeCodePackage];
      };
    };
  };
}
