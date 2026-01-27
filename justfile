

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

# Add a new neovim plugin. If branch is not specified, tracks releases (or default branch if no releases).
new-nvim-plugin start_opt user repo branch='':
    #!/bin/sh
    if [ -n "{{branch}}" ]; then
        npins --lock-file ./packages/neovim/{{start_opt}}.json add --name {{repo}} github {{user}} {{repo}} --branch {{branch}}
    else
        npins --lock-file ./packages/neovim/{{start_opt}}.json add --name {{repo}} github {{user}} {{repo}}
    fi
    NEW_VERSION=$(jq -rcn 'inputs | .pins | .[] | select(.repository.repo == "{{repo}}" ) | if .version != null then .version else .revision[0:8] end' packages/neovim/{{start_opt}}.json)
    git commit -am "chore(pin/new): {{repo}}: init @ $NEW_VERSION"
