{pkgs, ...}: {
  networking.hostId = "f98b90a0";
  networking.hostName = "polarbear";

  environment.systemPackages = with pkgs; [
    anki-bin
    ansible
    brave
    nixpkgs-review
    nix-update
  ];
}
