#!/bin/sh
pushd ~/repos/nix-dotfiles
sudo nixos-rebuild switch -I nixos-config=./nixos/configuration.nix
popd
