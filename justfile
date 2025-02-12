# just: https://just.systems

# List all recipes
default:
    @just --list --justfile {{ justfile() }}

# Build and activate a Darwin system configuration
[macos]
darwin:
    darwin-rebuild switch --flake .

# Build and activate a Home Manager configuration
home:
    nh home switch .

# Build and run Neovim (NixVim)
nvim:
    nix run .#nvim

# Update the lock file (optionally provide specific input(s))
update *INPUTS:
    nix flake update {{ INPUTS }}

# Open a development shell
dev:
    nix develop

# Format all files
fmt:
    just --unstable --fmt
    nix fmt .

# Link regular (not managed by Nix) dotfiles using GNU Stow
dotfiles:
    stow --dotfiles --restow --target $HOME dotfiles
