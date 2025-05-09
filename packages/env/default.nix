{
  inputs',
  #
  lib,
  symlinkJoin,
  #
  bat,
  carapace,
  difftastic,
  direnv,
  du-dust,
  eza,
  fd,
  fish,
  fq,
  gh,
  gnumake,
  hexyl,
  htop,
  fzf,
  jq,
  just,
  lazygit,
  lurk,
  magic-wormhole-rs,
  nix-index,
  psmisc,
  ripgrep,
  sops,
  starship,
  unar,
  vim,
  yazi,
}:
symlinkJoin {
  name = "env";
  paths =
    builtins.filter lib.isDerivation [
      bat
      carapace
      difftastic
      direnv
      du-dust
      eza
      fd
      fish
      fq
      gh
      gnumake
      hexyl
      htop
      fzf
      jq
      just
      lazygit
      lurk
      magic-wormhole-rs
      nix-index
      psmisc
      ripgrep
      sops
      starship
      unar
      vim
      yazi
    ]
    # ++ [
    # inputs'.
    # ]
    ;
}
