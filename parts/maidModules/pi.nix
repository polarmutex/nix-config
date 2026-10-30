{inputs, ...}: {
  # Pi coding agent. Subscription auth (Claude Pro/Max, ChatGPT Codex) is done
  # at runtime via `/login` inside pi, so no secrets are managed here.
  flake.maidModules.pi = {
    pkgs,
    config,
    lib,
    ...
  }: let
    cfg = config.pi;
    json = pkgs.formats.json {};
  in {
    options.pi = {
      package = lib.mkOption {
        type = lib.types.package;
        default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
        description = "Pi package to install.";
      };
      settings = lib.mkOption {
        type = json.type;
        default = {};
        example = {
          defaultThinkingLevel = "high";
          skills = ["/home/polar/vault/aios/skills"];
        };
        description = "Contents of ~/.pi/agent/settings.json.";
      };
      files = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = {};
        example = lib.literalExpression ''{"AGENTS.md" = ./AGENTS.md;}'';
        description = "Extra files linked into ~/.pi/agent, keyed by relative path (AGENTS.md, APPEND_SYSTEM.md, prompts/x.md, ...).";
      };
    };

    config = {
      packages = [cfg.package];
      file.home =
        lib.mapAttrs' (name: src: lib.nameValuePair ".pi/agent/${name}" {source = src;}) cfg.files
        // lib.optionalAttrs (cfg.settings != {}) {
          ".pi/agent/settings.json".source = json.generate "pi-settings.json" cfg.settings;
        };
    };
  };
}
