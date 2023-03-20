inputs: {
  bluetooth = import ./bluetooth.nix inputs;
  caches = import ./caches.nix inputs;
  core = import ./core.nix inputs;
  display-manager = import ./display-manager.nix inputs;
  doas = import ./doas.nix inputs;
  flake = import ./flake.nix inputs;
  fonts = import ./fonts.nix inputs;
  graphical = import ./graphical.nix inputs;
  mosh = import ./mosh.nix inputs;
  nix = import ./nix.nix inputs;
  nvidia = import ./nvidia.nix inputs;
  openssh = import ./openssh.nix inputs;
  trusted = import ./trusted.nix inputs;
  virt-manager = import ./virt-manager.nix inputs;
  wm-helper = import ./wm-helper.nix inputs;
  yubikey = import ./yubikey.nix inputs;
}
