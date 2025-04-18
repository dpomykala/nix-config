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

    # Support for OpenGL on non-NixOS Linux distributions
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim (NixVim) configuration: https://github.com/dpomykala/nix-nvim
    nix-nvim = {
      url = "github:dpomykala/nix-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = {
    home-manager,
    nix-darwin,
    nix-homebrew,
    nixpkgs,
    self,
    ...
  }: let
    supportedSystems = ["x86_64-darwin" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    darwinConfigurations = {
      # NOTE: Names should match the `scutil --get LocalHostName` command output

      "mbp-13" = nix-darwin.lib.darwinSystem {
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./system/hosts/mbp-13
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
      };
    });

    # Format Nix files with `nix fmt .`
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
