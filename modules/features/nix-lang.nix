_: {
  flake.modules.homeManager.nix-lang = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Nix language server
      nixd
      # Official Nix formatter
      nixfmt
      # Linter for Nix code, which `just lint` runs
      statix
    ];
  };
}
