{ inputs, ... }: {
  flake.nixosModules.hermes-agent-service = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.hermes-agent-service;
  in {
    imports = [inputs.hermes-agent.nixosModules.default];

    options.services.hermes-agent-service = {
      enable = lib.mkEnableOption "Hermes Agent gateway service";

      model = lib.mkOption {
        type = lib.types.str;
        default = "anthropic/claude-sonnet-4-20250514";
        description = "Default model (OpenRouter format or native provider ID).";
      };

      secretsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "config.sops.secrets.hermes-env.path";
        description = ''
          Path to an env file containing API keys, e.g.:
            OPENROUTER_API_KEY=sk-or-...
            ANTHROPIC_API_KEY=sk-ant-...
          Use sops-nix or agenix to manage this file.
        '';
      };

      hostUsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Users to receive a ~/.hermes symlink to the shared service state.";
      };

      containerEnable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Run inside a persistent Ubuntu container (allows apt/pip/npm installs).";
      };

      workingDirectory = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Agent working directory (visible to the agent as its workspace).";
      };

      extraDependencyGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "pyproject.toml optional extras to include (e.g. [ \"messaging\" ] for Telegram/Discord/Slack).";
      };
    };

    config = lib.mkIf cfg.enable {
      services.hermes-agent = {
        enable = true;
        addToSystemPackages = true;

        settings.model.default = cfg.model;

        environmentFiles = lib.optional (cfg.secretsFile != null) cfg.secretsFile;

        extraDependencyGroups = cfg.extraDependencyGroups;

        workingDirectory = lib.mkIf (cfg.workingDirectory != null) cfg.workingDirectory;

        container = lib.mkIf cfg.containerEnable {
          enable = true;
          hostUsers = cfg.hostUsers;
        };
      };
    };
  };
}
