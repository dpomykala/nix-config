/*
  Flake configuration outputs.

  Standalone Home Manager configurations get the canonical `pkgs` of the
  flake-parts `perSystem` scope through `withSystem`. See
  `modules/flake/nixpkgs.nix`.
*/
{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.darwinConfigurations = {
    # Each name must match the output of `scutil --get LocalHostName`

    "mbp-private" = inputs.nix-darwin.lib.darwinSystem {
      modules = [ self.modules.darwin.mbp-private ];
    };

    "mbp-positive" = inputs.nix-darwin.lib.darwinSystem {
      modules = [ self.modules.darwin.mbp-positive ];
    };
  };

  # Standalone Home Manager configurations
  flake.homeConfigurations = {
    # Each hostname must match the output of `hostname`

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
