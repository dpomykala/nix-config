{
  perSystem = {pkgs, ...}: {
    # Format Nix files with `nix fmt .`
    formatter = pkgs.alejandra;
  };
}
