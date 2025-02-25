{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./colorschemes.nix
    ./diagnostics.nix
    ./ftplugins.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  # Use the Neovim Nightly build
  package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
}
