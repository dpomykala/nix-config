/*
  This feature wires Nixpkgs for all configuration classes.

  The canonical Nixpkgs set is configured only once in the flake-parts
  `perSystem` scope (see: `modules/flake/nixpkgs.nix`). This canonical
  package-set is re-used for all configuration classes (NixOS, nix-darwin,
  Home Manager).

  Note: Standalone HM is wired at the home configuration construction
  rather than here.
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
