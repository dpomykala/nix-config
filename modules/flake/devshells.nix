{
  perSystem = { pkgs, ... }: {
    # Run development environment with `nix develop`
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        fzf
        jq
        just
        nh
        nixfmt
        nixfmt-tree
        sops
        stow
      ];
    };
  };
}
