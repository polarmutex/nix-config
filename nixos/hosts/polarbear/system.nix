{pkgs, ...}: {
  networking.hostId = "f98b90a0";
  networking.hostName = "polarbear";

  environment.systemPackages = with pkgs; [
    nixpkgs-review
    nix-update
  ];
}
