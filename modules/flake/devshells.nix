{
  perSystem = {pkgs, ...}: {
    # Run development environment with `nix develop`
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        alejandra
        fzf
        jq
        just
        nh
        sops
        stow
      ];
    };
  };
}
