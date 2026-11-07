

dump-gnome:
    dconf dump /org/gnome/ > misc/dconf-gnome

# Update only private git.polarmutex.dev npins inputs
update-private:
    @echo "Updating private git.polarmutex.dev inputs..."
    npins update monolisa-font-flake beancount-repo
    @echo "✅ Private inputs updated"

# Update all public npins inputs (excludes private git.polarmutex.dev inputs)
update-public:
    @echo "Updating public npins inputs..."
    npins update $(jq -r '.pins | keys[] | select(. != "monolisa-font-flake" and . != "beancount-repo")' npins/sources.json)
    @echo "✅ Public inputs updated"

# Update all npins inputs (both public and private)
update-all:
    @echo "Updating all npins inputs..."
    npins update
    @echo "✅ All inputs updated"

# Start the Obsidian Xvfb system services (xvfb + obsidian-xvfb) on polarvortex
start-obsidian-xvfb:
    systemctl start xvfb.service obsidian-xvfb.service

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

# Build locally and deploy polarvortex over SSH
deploy-polarvortex:
    nh os switch . --hostname polarvortex --target-host polar@polarvortex -e passwordless -v
