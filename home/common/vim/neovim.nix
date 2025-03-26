{
  self,
  pkgs,
  ...
}: {
  home = {
    packages = [
      # Use the NixVim derivation from this flake
      self.packages.${pkgs.system}.nvim
    ];

    # Set Neovim as the default editor
    sessionVariables.EDITOR = "nvim";

    shellAliases.v = "nvim";
  };
}
