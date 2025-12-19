{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cuda;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "gemma3:4b"
      "gemma3:12b"
      "qwen:4b"
      "qwen3:8b"
      "qwen3:14b"
      "qwen2.5-coder:7b"
      "qwen2.5-coder:14b"
      "mxbai-embed-large"
    ];
  };
}
