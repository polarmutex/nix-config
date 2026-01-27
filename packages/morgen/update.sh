#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch

set -euo pipefail

# URL to check for the latest version
latestUrl="https://dl.todesktop.com/210203cqcj00tw1/linux/deb/x64"

# Fetch the latest version information
latestInfo=$(curl -sI -X GET $latestUrl | grep -oP 'morgen-\K\d+(\.\d+)*(?=[^\d])')

if [[ -z "$latestInfo" ]]; then
    echo "Could not find the latest version number."
    exit 1
fi

# Extract the version number
latestVersion=$(echo "$latestInfo" | head -n 1)

echo "Latest version of Morgen is $latestVersion"

# Get current version from default.nix
currentVersion=$(grep -oP 'version = "\K[^"]+' "$(dirname "$0")/default.nix")

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Already at latest version $latestVersion"
    exit 0
fi

echo "Updating from $currentVersion to $latestVersion"

# Fetch new hash
newUrl="https://dl.todesktop.com/210203cqcj00tw1/versions/${latestVersion}/linux/deb"
newHash=$(nix-prefetch-url --type sha256 "$newUrl")
newHash=$(nix hash convert --hash-algo sha256 --to sri "$newHash")

# Update default.nix
sed -i "s/version = \".*\";/version = \"$latestVersion\";/" "$(dirname "$0")/default.nix"
sed -i "s|hash = \".*\";|hash = \"$newHash\";|" "$(dirname "$0")/default.nix"

echo "Updated morgen to $latestVersion with hash $newHash"
