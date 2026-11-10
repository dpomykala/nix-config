/*
  Passes the canonical Nixpkgs set to nix-darwin. The flake-parts `perSystem`
  scope configures the set once, in `modules/flake/nixpkgs.nix`, and every
  configuration class reuses it.

  Standalone Home Manager gets the set in `modules/flake/configurations.nix`
  instead. The NixOS variant below stays commented out until a NixOS host
  exists.
*/
{
  # inputs,
  moduleWithSystem,
  ...
}:
{
  flake.modules.darwin.nixpkgs = moduleWithSystem (
    { pkgs, ... }: _: {
      nixpkgs.pkgs = pkgs;
    }
  );

  # flake.modules.nixos.nixpkgs = moduleWithSystem (
  #   {pkgs, ...}: _: {
  #     # Prevent other modules from re-configuring Nixpkgs
  #     imports = [inputs.nixpkgs.nixosModules.readOnlyPkgs];
  #
  #     nixpkgs.pkgs = pkgs;
  #   }
  # );
}
