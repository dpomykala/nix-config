# Nix Config

These are my _dotfiles on steroids_ 🚀 created using [Nix].

## ✨ Features

- Managing MacOS system configuration with [nix-darwin].
- Managing [Homebrew] installed software on MacOS with nix-darwin.
- Managing user configuration with [Home Manager].
- Standalone Home Manager setup with support for non-NixOS Linux.
- Custom [Neovim configuration] using [NixVim].
- Declarative and reproducible configuration based on Nix [flake](flake.nix).
- Awesome tools for development and day-to-day use.
- Flexible, modular and easy to extend structure.
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
change all references, e.g. in [flake.nix](flake.nix).

If you are new to the Nix world, you should probably first familiarize
yourself with topics such as Nix (with flakes), nix-darwin, Home Manager
and NixVim. **In the future, I plan to extend this documentation to be more
beginner friendly.**

## Secrets management

Secrets are managed using [SOPS] and [sops-nix]. [age] is used for encryption.

### Creating secrets

1. Enter a development shell with `age` and `sops` installed:

   ```bash
   nix develop
   ```

2. Generate the age key pair to be used for encrypting secrets:

   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   ```

   - The location of this file is important.
   - Back up this file to a safe place (e.g. password manager).
   - The public key for the generated key pair should be displayed.

3. Copy the public key for the generated key pair. You can display
   public key(s) with the following command:

   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

4. Add the public key to the [.sops.yaml](.sops.yaml) file:

   ```yaml
   creation_rules:
     - age: <PUBLIC_KEY>
   ```

   - Remove any previous keys if not needed.
   - This is the simplest configuration with a single key.
   - This key will be used for all secrets in this repository.

5. To create or edit an encrypted file in this repository:

   ```bash
   sops <FILE>
   ```

6. You can also encrypt an existing file:

   ```bash
   sops --encrypt --in-place <FILE>
   ```

### Using secrets

When using this repository on a new machine, make sure to first copy
your age private key(s) to `~/.config/sops/age/keys.txt`.

## ✅ TODO

- Extend documentation.
- Add basic configuration for IdeaVim?
- Configure VSCode?
- Configure Podman via Home Manager?
- Add more settings for MacOS (e.g. for Safari)?
- Extend configuration for generic Linux hosts (e.g. more tools)?
- Test on WSL?
- Create NixOS configuration?
- nix-darwin: allow to set the config dir for Starship?
- nix-darwin: `/share/zsh` added to `environment.pathsToLink` by default?
- Home Manager: mise settings as separate file are invalid?

[age]: https://github.com/FiloSottile/age
[home manager]: https://github.com/nix-community/home-manager
[homebrew]: https://brew.sh
[just]: https://github.com/casey/just
[neovim configuration]: https://github.com/dpomykala/nix-nvim
[nix-darwin]: https://github.com/LnL7/nix-darwin
[nix]: https://nix.dev
[nixvim]: https://github.com/nix-community/nixvim
[sops]: https://github.com/getsops/sops
[sops-nix]: https://github.com/Mic92/sops-nix
