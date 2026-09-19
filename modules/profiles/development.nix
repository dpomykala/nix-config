# Development environment profile.
{ self, ... }: {
  flake.modules.homeManager.development = {
    imports = with self.modules.homeManager; [
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
  };
}
