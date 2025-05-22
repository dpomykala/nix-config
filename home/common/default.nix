/*
Configuration common to all hosts.
*/
{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./eza.nix
    ./fonts.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./mise.nix
    ./shell
    ./sops.nix
    ./ssh.nix
    ./starship.nix
    ./thefuck.nix
    ./uv.nix
    ./vim
    ./wezterm.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home = {
    # The version used for backwards compatibility
    stateVersion = "24.11";

    packages = with pkgs; [
      dust
      fd
      httpie
      hurl
      jq
      just
      lazydocker
      # NOTE: nh does not support nix-darwin (only NixOS and Home Manager)
      nh
      posting
      ripgrep
      ruff
      sd
      tlrc
      tokei
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
