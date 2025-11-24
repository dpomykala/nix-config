# just: https://just.systems

set unstable := true

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
    @nix flake metadata --json | jq '.locks.nodes.root.inputs | keys[]' | tr -d '"'

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

# Open a development shell
[group("Helpers")]
dev:
    nix develop

# Format all files
[group("Helpers")]
fmt:
    just --unstable --fmt
    nix fmt .

# Link files not managed by Nix (using GNU Stow)
[group("Helpers")]
stow: (_requires "stow")
    stow --dotfiles --restow --target $HOME stow

# TODO: Make it more robust, e.g. check architecture using arch()

# Download and install the 1Password .deb package for x86-64 Linux
[group("Helpers")]
[linux]
deb-1password: (_requires "curl")
    curl -o /tmp/1password.deb {{ onepassword_deb_x86_64_url }}
    sudo apt install /tmp/1password.deb
    rm /tmp/1password.deb
