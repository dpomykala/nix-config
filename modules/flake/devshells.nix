{
  perSystem = {pkgs, ...}: {
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
  };
}
