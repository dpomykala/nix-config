# Development environment profile.
{ self, ... }: {
  flake.modules.darwin.development = {
    imports = with self.modules.darwin; [
      docker
      shell
    ];
  };

  flake.modules.homeManager.development = {
    imports = with self.modules.homeManager; [
      # Features
      ai
      bat
      delta
      dev-tools
      docker
      eza
      fzf
      ghostty
      helix
      herdr
      http
      mise
      neovim
      pay-respects
      python
      shell
      ssh
      starship
      vim
      wezterm
      yazi
      zoxide
    ];

    # Choose the default editor here, not in an editor feature, so that only
    # one module sets it
    home.sessionVariables.EDITOR = "nvim";
  };
}
