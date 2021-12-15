{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  users.users.root.initialPassword = "root";
}
