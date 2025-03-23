/*
Configuration common to all hosts.
*/
{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./mise.nix
    ./nvim.nix
    # FIXME: MacOS specific?
    ./ssh.nix
    ./starship.nix
    ./thefuck.nix
    ./vim
    ./wezterm.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh
  ];

  home = {
    # The version used for backwards compatibility
    stateVersion = "24.11";

    packages = with pkgs; [
      dust
      eza
      fd
      httpie
      jq
      just
      lazydocker
      # NOTE: nh does not support nix-darwin (only NixOS and Home Manager)
      nh
      # TODO: Can it be completely replaced with uv?
      pipx
      ripgrep
      ruff
      sd
      tlrc
      tokei
      uv
    ];
  };

  # Allow installation of software with an unfree license
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself
  # NOTE: This option only works with a standalone Home Manager setup
  programs.home-manager.enable = true;

  # Set XDG environment variables
  xdg.enable = true;
}
