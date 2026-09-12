/*
  Configuration for the canonical Nixpkgs set.

  This Nixpkgs set is re-used for all configuration classes
  (see: `modules/features/nixpkgs.nix`).
*/
{
  inputs,
  self,
  ...
}:
{
  perSystem = { system, ... }: {
    # Configure the canonical Nixpkgs set with applied overlays
    # NOTE: These are `pkgs` used in the flake-parts `perSystem` scope
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;

      overlays = [
        # Apply the overlay with custom packages
        self.overlays.default
      ];
    };
  };
}
