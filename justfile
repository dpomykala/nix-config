# just: https://just.systems

onepassword_deb_x86_64_url := "https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"

# List all recipes
_default:
    @just --list --unsorted --justfile {{ justfile() }}

# Build and activate a Darwin system configuration
[macos]
darwin host="":
    nh darwin switch {{ if host != "" { "--hostname '" + host + "' " } else { "" } }}.

# Build and activate a Home Manager configuration
home config="":
    nh home switch {{ if config != "" { "--configuration '" + config + "' " } else { "" } }}.

# Update the lock file and commit (optionally provide specific input(s))
update *inputs:
    nix flake update --commit-lock-file {{ inputs }}

# Open a development shell
dev:
    nix develop

# Format all files
fmt:
    just --unstable --fmt
    nix fmt .

# Link files not managed by Nix (using GNU Stow)
stow:
    stow --dotfiles --restow --target $HOME stow

# TODO: Make it more robust, e.g. check architecture using arch()

# Download and install the 1Password .deb package for x86-64 Linux
[linux]
deb-1password:
    curl -o /tmp/1password.deb {{ onepassword_deb_x86_64_url }}
    sudo apt install /tmp/1password.deb
    rm /tmp/1password.deb
