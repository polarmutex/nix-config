{ config, pkgs, lib, ... }:
with lib;
{
    nix = {

      # Enable flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
      '';
      # cachix stuffs
      settings.substituters = [
        "https://cache.nixos.org"
        "https://cachix.cachix.org"
        "https://polarmutex.cachix.org"
        "http://nix-community.cachix.org"
      ];
      settings.trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
}
