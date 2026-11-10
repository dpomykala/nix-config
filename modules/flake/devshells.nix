{
  perSystem = { pkgs, ... }: {
    # Enter with `nix develop` or `just dev`
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        fzf
        jq
        just
        nh
        nixfmt
        nixfmt-tree
        oxfmt
        sops
        statix
        stow
      ];
    };
  };
}
