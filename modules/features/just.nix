_: {
  flake.modules.homeManager.just = { pkgs, ... }: {
    home.packages = with pkgs; [
      just
      just-lsp
    ];
  };
}
