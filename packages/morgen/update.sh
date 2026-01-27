#!/usr/bin/env bash
# Helper script to update Morgen package version

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current version from default.nix
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' default.nix || echo "unknown")

echo -e "${BLUE}Morgen Package Updater${NC}"
echo -e "${BLUE}=====================${NC}"
echo ""
echo -e "Current version in default.nix: ${GREEN}$CURRENT_VERSION${NC}"
echo ""

# Check if version was provided as argument
if [[ $# -eq 1 ]]; then
    NEW_VERSION="$1"
    echo -e "${YELLOW}Updating to version: $NEW_VERSION${NC}"
    echo ""

    # Ask for confirmation
    read -p "Proceed with update? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd ../..
        echo -e "${GREEN}Running nix-update...${NC}"
        nix-update morgen --flake --version="$NEW_VERSION" --build
        echo -e "${GREEN}Update complete!${NC}"
    else
        echo -e "${YELLOW}Update cancelled.${NC}"
    fi
else
    echo -e "${YELLOW}To find the latest version:${NC}"
    echo "  1. Visit https://morgen.so/download"
    echo "  2. Check the version number shown on the download page"
    echo ""
    echo -e "${YELLOW}To update this package, run:${NC}"
    echo ""
    echo -e "  ${GREEN}# Using this script:${NC}"
    echo "  ./update.sh VERSION_NUMBER"
    echo ""
    echo -e "  ${GREEN}# Or use nix-update directly from repo root:${NC}"
    echo "  nix-update morgen --flake --version=VERSION_NUMBER --build"
    echo ""
    echo -e "${BLUE}Example:${NC}"
    echo "  ./update.sh 3.6.20"
    echo ""
fi
