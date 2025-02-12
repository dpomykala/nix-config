# Dotfiles

The files that are linked to the user home directory and are **not** handled by
Nix. [GNU Stow](https://www.gnu.org/software/stow/) is used for managing these
links.

## Quickstart

Run a dev shell to make sure you have Stow and [just](https://just.systems)
available:

```
nix develop
```

and then to (re)link all files:

```
just dotfiles
```

If a file already exists and is not a symlink managed by Stow, the operation
will be aborted.

See the [justfile](../justfile) for the full Stow command being used.

## File structure

The files have the same structure as the expected symlinks in the home
directory.

When creating symlinks, the `dot-` prefix is replaced with the `.` prefix.

The `README.md` file is ignored by default.

For the example dotfiles below:

```
.
├── dot-config
│   └── someapp
│       └── config.toml
├── README.md
└── somefile
```

the following symlinks are created inside the home directory:

```
$HOME
├── .config
│   └── someapp
│       └── config.toml
└── somefile
```

## Motivation

In some cases, using Nix to handle (dot)files is not optimal. By default,
symlinks created by Nix point to paths inside the Nix store (`/nix/store/`).
These files cannot be modified by a non-root user, making them immutable.

This has two main drawbacks:

1. Files cannot be edited with a GUI. E.g. it's not possible to configure
   Karabiner-Elements from inside the application.
2. You cannot iterate quickly when working on a file, each change requires
   rebuilding the whole system or the Home Manager configuration.

## What about `mkOutOfStoreSymlink`?

Home Manager provides the `config.lib.file.mkOutOfStoreSymlink` function that
allows to create a symlink to a path outside of the Nix store. It creates a
symlink chain that goes through the Nix store, but ends up at the source file
(outside of the store).

Unfortunately, with flakes this only works when the function is called with an
absolute path. This means that the flake configuration must be aware of its
location in the file system, which complicates things.

This option is worth further exploaration in the future.

