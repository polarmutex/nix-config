# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= polar

# Settings
NIXBLOCKDEVICE ?= sda

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
	# garbage collect all unused nix store entries
	sudo nix store gc --debug

history:
	nix profile history --profile /nix/var/nix/profiles/system

switch:
	sudo nixos-rebuild switch --flake .#

test:
	sudo nixos-rebuild test --flake .#

check:
	nix flake check

update:
	nix flake update

polarbear:
	sudo nixos-rebuild switch --flake .#polarbear

blackbear:
	#sudo nixos-rebuild switch --flake .#blackbear
	deploy ".#blackbear" -d --hostname 192.168.122.44

polarvortex:
	deploy ".#polarvortex" --ssh-user "polar"  --hostname brianryall.xyz

polarbear-home:
	home-manager switch  --flake .#"polar@polarbear"

work:
	home-manager switch  --flake .#"user@work"

update_neovim:
	nix flake lock --update-input neovim-flake;
update_awesome:
	nix flake lock --update-input awesome-flake;
update_wallpapers:
	nix flake lock --update-input wallpapers;
update_website:
	nix flake lock --update-input website;

.PHONY: clean
clean:
	rm -rf result
