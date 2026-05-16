{
  flake.nixosModules.claude = {
    inputs,
    pkgs,
    ...
  }: {
    services.claude-cowork.enable = true;
    services.claude-cowork.extraPath = [pkgs.claude-code-polar];
    environment.systemPackages = [
      inputs.claude-desktop.packages.x86_64-linux.default
      pkgs.claude-code-polar
    ];
  };
}
