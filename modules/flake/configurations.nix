/*
  Flake configuration outputs.

  For Home Manager `withSystem` is used to pass the canonical `pkgs` configured
  in the flake-parts `perSystem` scope (see: `modules/flake/nixpkgs.nix`).
*/
{
  inputs,
  self,
  withSystem,
  ...
}:
{
  # Darwin system configurations
  flake.darwinConfigurations = {
    # NOTE: Names should match the `scutil --get LocalHostName` command output

    "mbp-private" = inputs.nix-darwin.lib.darwinSystem {
      modules = [ self.modules.darwin.mbp-private ];
    };

    "mbp-positive" = inputs.nix-darwin.lib.darwinSystem {
      modules = [ self.modules.darwin.mbp-positive ];
    };
  };

  # Standalone Home Manager configurations
  flake.homeConfigurations = {
    # NOTE: Hostnames should match the `hostname` command output

    "dp@mbp-private" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ self.modules.homeManager."dp@mbp-private" ];
      pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
    };

    "dp@mbp-positive" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ self.modules.homeManager."dp@mbp-positive" ];
      pkgs = withSystem "aarch64-darwin" ({ pkgs, ... }: pkgs);
    };

    "dp@vm-ubuntu" = inputs.home-manager.lib.homeManagerConfiguration {
      modules = [ self.modules.homeManager."dp@vm-ubuntu" ];
      pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
    };
  };
}
