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
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/ddd7747c41a3d12106c6a8d9c81720e13460b761";
    # Secrets management with SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    home-manager,
    nix-darwin,
    nixpkgs,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        # Run development environment with `nix develop`
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            age
            alejandra
            just
            nh
            sops
            stow
          ];
        };

        # Format Nix files with `nix fmt .`
        formatter = pkgs.alejandra;
      };

      flake = {
        darwinConfigurations = {
          # NOTE: Names should match the `scutil --get LocalHostName` command output

          "mbp-16" = nix-darwin.lib.darwinSystem {
            modules = [./system/hosts/mbp-16];
            specialArgs = {inherit self;};
          };
        };

        # The standalone Home Manager configurations
        homeConfigurations = {
          # NOTE: Hostnames should match the `hostname` command output

          "dp@mbp-16" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {inherit self;};
            modules = [(./. + "/home/configs/dp@mbp-16")];
            pkgs = nixpkgs.legacyPackages."x86_64-darwin";
          };

          "dp@ubuntu-vm" = home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {inherit self;};
            modules = [(./. + "/home/configs/dp@ubuntu-vm.nix")];
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
          };
        };
      };

      # Supported systems
      systems = ["x86_64-darwin" "x86_64-linux"];
    };
}
