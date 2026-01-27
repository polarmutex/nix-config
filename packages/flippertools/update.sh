#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-prefetch-git

set -euo pipefail

# GitHub repository
owner="astrospark"
repo="flippertools"

# Get the latest commit information from the main branch
latestCommitInfo=$(curl -s "https://api.github.com/repos/$owner/$repo/commits/main")

# Extract commit SHA and date
latestSha=$(echo "$latestCommitInfo" | jq -r '.sha')
latestDate=$(echo "$latestCommitInfo" | jq -r '.commit.committer.date' | cut -d'T' -f1)

if [[ -z "$latestSha" ]]; then
    echo "Could not find the latest commit SHA."
    exit 1
fi

echo "Latest commit on main is $latestSha from $latestDate"

# Get current version from default.nix
currentRev=$(sed -n 's/.*rev = "\(.*\)";/\1/p' "$(dirname "$0")/default.nix")

if [[ "$currentRev" == "$latestSha" ]]; then
    echo "Already at latest commit $latestSha"
    exit 0
fi

echo "Updating from $currentRev to $latestSha"

# Fetch new hash
newHash=$(nix-prefetch-git --url "https://github.com/$owner/$repo.git" --rev "$latestSha" | jq -r '.sha256')
newSriHash=$(nix hash convert --hash-algo sha256 --to sri "sha256-$newHash")

# Update default.nix
sed -i "s/version = \".*\";/version = \"unstable-$latestDate\";/" "$(dirname "$0")/default.nix"
sed -i "s/rev = \".*\";/rev = \"$latestSha\";/" "$(dirname "$0")/default.nix"
sed -i "s|hash = \".*\";|hash = \"$newSriHash\";|" "$(dirname "$0")/default.nix"

echo "Updated flippertools to commit $latestSha (version unstable-$latestDate) with hash $newSriHash"
