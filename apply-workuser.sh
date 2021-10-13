#!/bin/sh
nix build .#homeManagerConfigurations.work.activationPackage
./result/activate
