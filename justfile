

dump-gnome:
    dconf dump /org/gnome/ > misc/dconf-gnome

# Update only private git.polarmutex.dev flake inputs
update-private:
    @echo "Updating private git.polarmutex.dev inputs..."
    nix flake lock --update-input monolisa-font-flake
    nix flake lock --update-input wallpapers
    nix flake lock --update-input beancount-repo
    @echo "✅ Private inputs updated"

# Update all public flake inputs (excludes private git.polarmutex.dev inputs)
update-public:
    @echo "Updating public flake inputs..."
    @nix flake metadata --json | jq -r '.locks.nodes.root.inputs | to_entries[] | select(.key != "monolisa-font-flake" and .key != "wallpapers" and .key != "beancount-repo") | .key' | while read input; do \
        echo "→ Updating $$input..."; \
        nix flake lock --update-input "$$input"; \
    done
    @echo "✅ Public inputs updated"

# Update all flake inputs (both public and private)
update-all:
    @echo "Updating all flake inputs..."
    nix flake update
    @echo "✅ All inputs updated"
