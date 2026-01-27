# Morgen Package

All-in-one Calendars, Tasks and Scheduler application for NixOS.

## Updating

This package can be updated using `nix-update` by specifying the version explicitly:

```bash
# Check the latest version at: https://dl.todesktop.com/210203cqcj00tw1/linux/deb/x64
# Then update with the specific version
nix-update morgen --flake --version=3.6.20

# With automatic build verification
nix-update morgen --flake --version=3.6.20 --build

# With automatic commit
nix-update morgen --flake --version=3.6.20 --build --commit
```

### Finding the Latest Version

You can find the latest version by checking the redirect from:
```bash
curl -sI https://dl.todesktop.com/210203cqcj00tw1/linux/deb/x64 | grep -i location
```

## Manual Update

Alternatively, you can manually update:

1. Check the latest version at: https://dl.todesktop.com/210203cqcj00tw1/linux/deb/x64
2. Update the `version` field in `default.nix`
3. Set the `hash` field to an empty string: `hash = "";`
4. Run `nix build .#morgen` - Nix will show the correct hash
5. Update the `hash` field with the correct value

## Usage

Add to your system or home-manager configuration:

```nix
environment.systemPackages = with pkgs; [
  morgen
];
```

Or for home-manager:

```nix
home.packages = with pkgs; [
  morgen
];
```

## Notes

- This package is unfree software
- Only supports x86_64-linux
- Includes Wayland support via NIXOS_OZONE_WL environment variable
