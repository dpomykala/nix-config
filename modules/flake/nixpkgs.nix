/*
  The canonical Nixpkgs set. Every configuration class reuses this set. See
  `modules/features/nixpkgs.nix`.
*/
{
  inputs,
  self,
  ...
}:
{
  perSystem = { system, ... }: {
    # The `pkgs` argument of every flake-parts `perSystem` module
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;

      overlays = [
        # Custom packages from pkgs/
        self.overlays.default
      ];
    };
  };
}
