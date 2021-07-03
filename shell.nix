{ pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  name = "flakesshell";
  buildInputs = with pkgs; [
    git
    nixUnstable
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
