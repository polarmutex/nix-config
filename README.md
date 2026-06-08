# PolarMutex Nix Config

Personal NixOS and home-manager configuration managed as a flake.

## Structure

```
.
├── flake.nix              # Flake inputs and outputs (flake-parts based)
├── parts/                 # Flake-parts modules (nixosConfigurations, homeConfigurations, etc.)
├── hosts/                 # Per-host NixOS configurations
│   ├── macbook-air-24/
│   └── vm-intel/
├── home-manager/          # Home-manager configurations
│   └── configurations/    # Per-user configs (polar@polarbear, brian@macbook-air-24, user@work)
├── modules/               # Reusable NixOS and home-manager modules
│   ├── home-manager/      # App configs: git, helix, zed, ghostty, tmux, etc.
│   └── nixos/             # System modules: hyprland, display-manager, etc.
├── packages/              # Custom packages: neovim, MCP tools, claude utilities, etc.
├── secrets/               # sops-nix encrypted secrets
├── npins/                 # Pinned sources (npins)
└── justfile               # Common tasks (update-public, update-private, new-nvim-plugin)
```

## Applying Configurations

**NixOS (switch current host):**
```bash
sudo nixos-rebuild switch --flake .#
```

**Home-manager:**
```bash
home-manager switch --flake .#"polar@polarbear"
home-manager switch --flake .#"brian@macbook-air-24"
home-manager switch --flake .#"user@work" --impure
```

**VM deployment:**
```bash
# Bootstrap a fresh VM (set NIXADDR to VM IP)
make vm/bootstrap0
make vm/bootstrap

# Deploy to running VM
make vm
```

## Updating Inputs

```bash
# Update public inputs only (skips private git.polarmutex.dev)
just update-public

# Update private inputs (monolisa-font-flake, wallpapers, beancount-repo)
just update-private

# Update everything
just update-all
```

## Maintenance

```bash
# Garbage collect (removes generations older than 7 days)
make gc

# Check flake
nix flake check

# View generation history
make history
```

## Key Tools & Inputs

- **flake-parts** — modular flake output composition
- **home-manager** — user environment management
- **nix-darwin** — macOS support
- **sops-nix** — secrets management
- **deploy-rs** — remote NixOS deployment
- **disko** — declarative disk partitioning
- **npins** — pinned non-flake sources
- **helix / zed / ghostty / tmux** — editor and terminal setup
- **MorgenMCP, context7-mcp, github-mcp** — MCP server packages

## nix-direnv

```bash
echo "use flake" >> .envrc && direnv allow
```

## Inspiration

- [wiltaylor](https://github.com/wiltaylor/dotfiles)
- [pinpox](https://github.com/pinpox/nixos)
- [Misterio77](https://github.com/Misterio77/nix-config)
- [fufexan](https://github.com/fufexan/dotfiles)
