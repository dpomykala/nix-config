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

    sessionVariables = {
      # Set Neovim as the default editor
      EDITOR = "nvim";
    };
  };
}
