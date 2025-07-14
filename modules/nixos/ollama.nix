{pkgs, ...}: {
  services.ollama = {
    enable = true;
    # package = pkgs.unstable.ollama;
    package = pkgs.unstable.ollama;
    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "gemma3:1b"
      "gemma3:4b"
    ];
    # acceleration = "cuda";
  };
}
