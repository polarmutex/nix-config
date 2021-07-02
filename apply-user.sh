#!/bin/sh
pushd ~/repos/nix-dotfiles
nix build .#homeManagerConfigurations.brian.activationPackage
./result/activate
popd
