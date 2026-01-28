{
  flake.nixosModules.user-polar = _: {
    imports = [
      (import ./_mkUser.nix "polar")
    ];

    users.users.polar = {
      uid = 10000;
    };
  };
}
