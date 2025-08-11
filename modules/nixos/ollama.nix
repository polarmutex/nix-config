{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "gemma3:4b"
      "gemma3:12b"
      "qwen:4b"
      "qwen:8b"
      "qwen:14b"
      "qwen2.5-coder:7b"
      "qwen2.5-coder:14b"
    ];
    acceleration = "cuda";
  };
}
