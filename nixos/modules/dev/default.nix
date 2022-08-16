{ pkgs, ... }: {
  imports = [ ];

  environment = {
    systemPackages = with pkgs; [
      nixpkgs-review
      nix-update
    ];
  };
}
