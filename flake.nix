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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    home-manager,
    nixvim,
    ...
  }: let
    supportedSystems = ["x86_64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Extend the default lib with custom functions
    lib = nixpkgs.lib.extend (final: prev: {
      custom = import ./lib {lib = final;};
    });
    # Extend the lib used for NixVim with the default NixVim lib
    libForNixvim = lib.extend nixvim.lib.overlay;
  in {
    darwinConfigurations."MacBook-Pro-Damian" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit self;};
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only
            #enableRosetta = true;

            # FIXME: Hardcoded username
            # User owning the Homebrew prefix
            user = "dp";

            # Use declarative tap management
            taps = {
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Enable fully-declarative tap management
            # Only taps declared in this configuration are allowed
            mutableTaps = false;
          };
        }

        # For reference: Home Manager can be used as a nix-darwin module
        # This allows to run Home Manager when running darwin-rebuild
        # I prefer to use a standalone Home Manager setup instead
        #home-manager.darwinModules.home-manager
        #{
        #  home-manager = {
        #    useGlobalPkgs = true;
        #    useUserPackages = true;
        #    users.dp = import ./home;
        #  };
        #}

        # The entrypoint for the nix-darwin configuration
        ./darwin
      ];
    };

    # The standalone Home Manager configuration
    # This can also be used on platforms other than NixOS and Darwin
    # FIXME: Hardcoded username
    homeConfigurations."dp" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-darwin";
      modules = [
        # The entrypoint for the Home Manager configuration
        ./home
      ];
      extraSpecialArgs = {inherit self;};
    };

    packages = forAllSystems (system: let
      # nixvimLib = nixvim.lib.${system};
      nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
        inherit system;
        module = import ./nixvim;
        extraSpecialArgs = {
          inherit inputs;
          # Use the custom (extended) lib
          lib = libForNixvim;
        };
      };
    in {
      # Run NixVim as the default program for this flake with `nix run`
      default = nvim;
      nvim = nvim;
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
  };
}
