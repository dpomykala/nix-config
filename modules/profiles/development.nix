# Development environment profile.
{ self, ... }: {
  flake.modules.homeManager.development = {
    imports = with self.modules.homeManager; [
      # Profiles
      base

      # Features
      ai
      bat
      delta
      docker
      eza
      fzf
      http
      mise
      neovim
      pay-respect
      python
      shell
      ssh
      starship
      vim
      wezterm
      yazi
      zoxide
    ];
  };
}
