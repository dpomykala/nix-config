{
  self,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # Use the custom Neovim (NixVim) configuration
      self.inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Set Neovim as the default editor
    sessionVariables.EDITOR = "nvim";

    shellAliases.v = "nvim";
  };
}
