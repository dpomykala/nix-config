{
  description = "Darwin system and Home Manager configurations";

  inputs = {
    bat-catppuccin-theme = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    delta-catppuccin-theme = {
      url = "github:catppuccin/delta";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    import-tree.url = "github:vic/import-tree";
    # Used by bat to enable syntax highlighting for just
    just-sublime = {
      url = "github:nk9/just_sublime";
      flake = false;
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Custom NixVim configuration: https://github.com/dpomykala/nix-nvim
    nix-nvim = {
      url = "github:dpomykala/nix-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Support for OpenGL on non-NixOS Linux distributions
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Secrets management with SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    import-tree,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager

        # Import all modules
        (import-tree ./modules)
      ];

      # Supported systems
      systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];
    };
}
