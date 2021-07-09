#!/bin/sh
pushd ~/repos/github/nix-dotfiles
nix build .#homeManagerConfigurations.work.activationPackage
./result/activate
popd
