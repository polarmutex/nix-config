{
  flake.nixosModules.ollama-service = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      environmentVariables = {
        OLLAMA_ORIGINS = "moz-extension://*,chrome-extension://*,safari-web-extension://*";
        OLLAMA_CONTEXT_LENGTH = "64000";
      };
      # Optional: preload models, see https://ollama.com/library
      loadModels = [
        "qwen3:14b"
        "qwen2.5-coder:14b"
        "gemma3:12b"
        "gpt-oss:20b"
        "ministral-3:14b"
      ];
    };
  };
}
