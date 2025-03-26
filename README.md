# Nix Config

These are my _dotfiles on steroids_ 🚀 created using [Nix].

## ✨ Features

- Managing MacOS system configuration with [nix-darwin].
- Managing [Homebrew] installed software on MacOS with nix-darwin.
- Managing user configuration with [Home Manager].
- Standalone Home Manager setup with support for non-NixOS Linux.
- Standalone [NixVim] setup with fully configured Neovim.
- Declarative and reproducible configuration based on Nix [flake](flake.nix).
- Neovim exposed as a flake package that can be used on its own.
- Awesome tools for development and day-to-day use.
- Flexible, modular and extendable structure.
- Support for multi-host and multi-user configurations.
- Clean and well documented code.
- Development shell for bootstrapping.
- Automated tasks using [just].

## 👀 Get started

For now, the best way to start is to fork the repo and adapt it to your needs.
Or to take some inspiration from it.

This configuration is **personalized** for me, so **do not run it as is**!

You should _at least_ replace files in the following directories:

- `home/configs`
- `home/hosts`
- `home/users`
- `system/hosts`

These should be files related to your hosts and users. Remember to also
change all references, e.g. in `flake.nix`.

If you are a beginner, you should probably first familiarize yourself with
topics such as Nix (with flakes), nix-darwin, Home Manager and NixVim. **In
the future, I plan to extend this documentation to be more beginner friendly.**

## ✅ TODO

- Extend documentation.
- Add basic configuration for IdeaVim?
- Configure VSCode?
- Configure Podman via Home Manager?
- Add more settings for MacOS (e.g. for Safari)?
- Extend configuration for generic Linux hosts (e.g. more tools)?
- Test on WSL?
- Explore options for secrets management?
- Create NixOS configuration?
- nix-darwin: allow to set the config dir for Starship?
- nix-darwin: `/share/zsh` added to `environment.pathsToLink` by default?
- Home Manager: mise settings as separate file are invalid?

[home manager]: https://github.com/nix-community/home-manager
[homebrew]: https://brew.sh
[just]: https://github.com/casey/just
[nix-darwin]: https://github.com/LnL7/nix-darwin
[nix]: https://nix.dev
[nixvim]: https://github.com/nix-community/nixvim
