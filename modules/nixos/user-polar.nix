_: {
  imports = [
    (import ./_mkUser.nix "polar")
  ];

  users.users.polar = {
    uid = 10000;
  };
}
