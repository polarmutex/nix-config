inputs: {
  "profiles" = import ./profiles inputs;
  "profiles/base" = import ./profiles/base.nix inputs;
  "profiles/fonts" = import ./profiles/fonts.nix inputs;
  "profiles/messaging" = import ./profiles/messaging.nix inputs;
  "profiles/trusted" = import ./profiles/trusted.nix inputs;
  "profiles/wallpapers" = import ./profiles/wallpaper.nix inputs;

  "programs/direnv" = import ./programs/direnv.nix inputs;
  "programs/eww" = import ./misc/leftwm/eww.nix inputs;
  "programs/firefox" = import ./programs/firefox.nix inputs;
  "programs/fish" = import ./programs/fish.nix inputs;
  "programs/helix" = import ./programs/helix.nix inputs;
  "programs/htop" = import ./programs/htop.nix inputs;
  "programs/kitty" = import ./programs/kitty.nix inputs;
  "programs/obsidian" = import ./programs/obsidian.nix inputs;
  "programs/protonvpn" = import ./programs/protonvpn.nix inputs;
  "programs/sioyek" = import ./programs/sioyek.nix inputs;
  "programs/tmux" = import ./programs/tmux.nix inputs;
  "programs/wezterm" = import ./programs/wezterm.nix inputs;
  "programs/zellij" = import ./programs/zellij.nix inputs;

  "misc/home" = import ./misc/home.nix inputs;
  "misc/leftwm" = import ./misc/leftwm/leftwm.nix inputs;

  "services/picom" = import ./services/picom.nix inputs;
  "services/window-managers/leftwm" = import ./services/window-managers/leftwm.nix inputs;
}
