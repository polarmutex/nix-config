{ inputs, ... }:
{
  config = {
    # For compatibility with nix-shell, nix-build, etc.
    home.file.".nixpkgs".source = inputs.nixpkgs;
    systemd.user.sessionVariables."NIX_PATH" =
      inputs.nixpkgs.lib.mkForce "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";
  };
}
