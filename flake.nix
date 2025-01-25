{
  description = "Darwin system and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
  }: let
    supportedSystems = ["x86_64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

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
    };
  };
}
