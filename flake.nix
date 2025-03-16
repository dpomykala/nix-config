{
  description = "Darwin system and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nix-darwin.follows = "nix-darwin";
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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Neovim plugins
    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    bat-catppuccin-theme = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    delta-catppuccin-theme = {
      url = "github:catppuccin/delta";
      flake = false;
    };
  };

  outputs = inputs @ {
    home-manager,
    nix-darwin,
    nix-homebrew,
    nixpkgs,
    nixvim,
    self,
    ...
  }: let
    supportedSystems = ["x86_64-darwin" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Extend the default lib with custom functions
    lib = nixpkgs.lib.extend (final: prev: {
      custom = import ./lib {lib = final;};
    });
    # Extend the lib used for NixVim with the default NixVim lib
    libForNixvim = lib.extend nixvim.lib.overlay;
  in {
    darwinConfigurations = {
      # NOTE: Names should match the `scutil --get LocalHostName` command output

      "MacBook-Pro-Damian" = nix-darwin.lib.darwinSystem {
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./darwin
        ];
        specialArgs = {inherit self;};
      };
    };

    # The standalone Home Manager configurations
    homeConfigurations = {
      # NOTE: Hostnames should match the `hostname` command output

      "dp@mbp-13" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit self;};
        modules = [(./. + "/home/configs/dp@mbp-13.nix")];
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
      };

      "dp@ubuntu-vm" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit self;};
        modules = [(./. + "/home/configs/dp@ubuntu-vm.nix")];
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
      };
    };

    packages = forAllSystems (system: let
      # nixvimLib = nixvim.lib.${system};
      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit system;

        extraSpecialArgs = {
          inherit self;

          # Use the custom (extended) lib
          lib = libForNixvim;
        };

        module = import ./nixvim;
      };
    in {
      inherit nvim;
      # Run NixVim as the default program for this flake with `nix run`
      default = nvim;
    });

    # TODO: Add checks for NixVim?

    # Run development environment with `nix develop`
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          alejandra
          just
          nh
          stow
        ];

        shellHook = ''exec zsh'';
      };
    });

    # Format Nix files with `nix fmt .`
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Export custom overlays
    overlays = import ./overlays {inherit inputs;};
  };
}
