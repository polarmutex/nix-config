# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= polar

# Settings
NIXBLOCKDEVICE ?= sda

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

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
	deploy ".#blackbear" -d --hostname 10.11.11.172

polarvortex:
	deploy ".#polarvortex" --ssh-user "polar"  --hostname brianryall.xyz

polar-hm:
	nix build .#homeConfigurations."polar@polarbear".activationPackage && result/activate && unlink result

work:
	nix build .#homeManagerConfigurations."work".activationPackage && result/activate && unlink result

update_local_neovim:
	nix flake lock --update-input neovim-flake --update-input awesome-flake

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
vm/bootstrap:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		parted /dev/$(NIXBLOCKDEVICE) -- mklabel gpt; \
		parted /dev/$(NIXBLOCKDEVICE) -- mkpart primary 512MiB -8GiB; \
		parted /dev/$(NIXBLOCKDEVICE) -- mkpart primary linux-swap -8GiB 100\%; \
		parted /dev/$(NIXBLOCKDEVICE) -- mkpart ESP fat32 1MiB 512MiB; \
		parted /dev/$(NIXBLOCKDEVICE) -- set 3 esp on; \
		mkfs.ext4 -L nixos /dev/$(NIXBLOCKDEVICE)1; \
		mkswap -L swap /dev/$(NIXBLOCKDEVICE)2; \
		mkfs.fat -F 32 -n boot /dev/$(NIXBLOCKDEVICE)3; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.package = pkgs.nixFlakes;\n \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
  			services.openssh.enable = true;\n \
			services.openssh.passwordAuthentication = true;\n \
			services.openssh.permitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd; \
		reboot; \
	"

# copy our secrets into the VM
vm/secrets:
	# SSH keys
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='environment' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh

#search pkg:
#  @echo "[INFO] Searching package {{pkg}}..."
#  nix search nixpkgs '\.{{pkg}}$'
#clean max-age="30":
#  @echo "[INFO] Deleting user and system garbage..."
#  nix profile list | awk '{print $NF}' | xargs nix profile remove
#  doas nix profile list | awk '{print $NF}' | doas xargs nix profile remove
#  nix-collect-garbage --delete-older-than {{max-age}}d
#  doas nix-collect-garbage --delete-older-than {{max-age}}d
#  git gc --aggressive
