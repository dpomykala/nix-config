# just: https://just.systems

onepassword_deb_x86_64_url := "https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"

# List all recipes
_default:
    @just --list --unsorted --justfile {{ justfile() }}

[no-exit-message]
_requires bin:
    @command -v {{ bin }} >/dev/null 2>&1 || { echo '{{ style("error") }}This recipe requires {{ bin }}{{ NORMAL }}'; exit 1; }

# Build and activate a Darwin system configuration
[group("Configurations")]
[macos]
darwin host="": (_requires "nh")
    nh darwin switch {{ if host != "" { "--hostname '" + host + "' " } else { "" } }}.

# Build and activate a Home Manager configuration
[group("Configurations")]
home config="": (_requires "nh")
    nh home switch {{ if config != "" { "--configuration '" + config + "' " } else { "" } }}.

# List all flake inputs
[group("Inputs")]
inputs: (_requires "jq")
    @nix flake metadata --json | jq -r '.locks.nodes.root.inputs | keys[]'

# Update the lock file and commit (optionally provide input(s))
[group("Inputs")]
update *inputs:
    nix flake update --commit-lock-file {{ inputs }}

# Update the lock file and commit (select input(s) interactively)
[group("Inputs")]
[script]
iupdate: (_requires "fzf") (_requires "jq")
    selected_inputs="$(just inputs | fzf -m --height ~20 | tr '\n' ' ')"
    if [ -z "$selected_inputs" ]; then
        echo "No input selected"
    else
        echo "Updating inputs: $selected_inputs"
        nix flake update --commit-lock-file $selected_inputs
    fi

# Restart the Nix daemon
[group("Helpers")]
[macos]
restart:
    sudo launchctl kickstart -k system/org.nixos.nix-daemon

# Open a development shell
[group("Helpers")]
dev:
    nix develop

# Format all files
[group("Helpers")]
fmt: (_requires "oxfmt")
    just --fmt
    nix fmt
    oxfmt

# Check the formatting without changing files. treefmt behind `nix fmt` has no
# check-only mode, so this runs nixfmt directly.
_fmt-check: (_requires "nixfmt") (_requires "oxfmt")
    just --fmt --check
    git ls-files -z '*.nix' | xargs -0 nixfmt --check
    oxfmt --check

# Lint Nix files
[group("Helpers")]
lint: (_requires "statix")
    statix check

# Check the formatting, lint, and evaluate all configurations
[group("Helpers")]
[script]
check: _fmt-check lint
    hosts="$(nix eval --raw .#darwinConfigurations --apply 'c: toString (builtins.attrNames c)')"
    for host in $hosts; do
        echo "Evaluating darwinConfigurations.$host"
        nix eval --raw ".#darwinConfigurations.$host.system.drvPath" >/dev/null
    done
    homes="$(nix eval --raw .#homeConfigurations --apply 'c: toString (builtins.attrNames c)')"
    for home in $homes; do
        echo "Evaluating homeConfigurations.\"$home\""
        nix eval --raw ".#homeConfigurations.\"$home\".activationPackage.drvPath" >/dev/null
    done
    nix flake check --all-systems

# Link files not managed by Nix (using GNU Stow)
[group("Helpers")]
stow: (_requires "stow")
    stow --dotfiles --restow --target $HOME stow

# Download and install the 1Password .deb package for x86-64 Linux
[group("Helpers")]
[linux]
deb-1password: (_requires "curl")
    @{{ if arch() != "x86_64" { error("The 1Password .deb package is only for x86-64") } else { "" } }}
    curl -fL -o /tmp/1password.deb {{ onepassword_deb_x86_64_url }}
    sudo apt install /tmp/1password.deb
    rm /tmp/1password.deb
