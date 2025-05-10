# Connectivity info for Linux VM
# NIXADDR ?= unset
NIXADDR ?= 172.16.193.128
NIXPORT ?= 22
NIXUSER ?= polar

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# The name of the nixosConfiguration in the flake
NIXNAME ?= vm-intel

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

vm:
	deploy ".#vm-intel" --ssh-user "polar"  --hostname 172.16.193.128

polarbear-home:
	home-manager switch  --flake .#"polar@polarbear"

work:
	home-manager switch  --flake .#"user@work" --impure

macbook-air-24:
	home-manager switch  --flake .#"brian@macbook-air-24"

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

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
#
# NOTE(mitchellh): I'm sure there is a way to do this and bootstrap all
# in one step but when I tried to merge them I got errors. One day.
vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		parted /dev/sda -- mklabel msdos; \
		parted /dev/sda -- mkpart primary 1MB -8GB; \
		parted /dev/sda -- set 1 boot on; \
		parted /dev/sda -- mkpart primary linux-swap -8GB 100\%; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/sda1; \
		mkswap -L swap /dev/sda2; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixVersions.latest;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
			nix.settings.substituters = [\"https://polarmutex.cachix.org\"];\n \
			nix.settings.trusted-public-keys = [\"polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08=\"];\n \
  			services.openssh.enable = true;\n \
			services.openssh.settings.PasswordAuthentication = true;\n \
			services.openssh.settings.PermitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
			boot.loader.grub.device = \"/dev/sda\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd && reboot; \
	"

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
vm/bootstrap:
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/switch
	$(MAKE) vm/secrets
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo reboot; \
	"

# copy our secrets into the VM
vm/secrets:
	# # GPG keyring
	# rsync -av -e 'ssh $(SSH_OPTIONS)' \
	# 	--exclude='.#*' \
	# 	--exclude='S.*' \
	# 	--exclude='*.conf' \
	# 	$(HOME)/.gnupg/ $(NIXUSER)@$(NIXADDR):~/.gnupg
	# SSH keys
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='environment' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh

# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='.git/' \
		--exclude='.git' \
		--exclude='.git-crypt/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nix-config

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo nixos-rebuild switch --flake \"/nix-config#${NIXNAME}\" \
	"
