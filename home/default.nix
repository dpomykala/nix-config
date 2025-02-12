{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git.nix
    ./karabiner
    ./mise.nix
    ./nvim.nix
    # FIXME: MacOS specific?
    ./ssh.nix
    ./starship.nix
    ./thefuck.nix
    ./vim
    ./wezterm
    ./yazi.nix
    ./zoxide.nix
    ./zsh
  ];

  # FIXME: Hardcoded username?
  home = {
    username = "dp";
    # FIXME: Use host-specific files?
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/dp"
      else "/home/dp";

    # The version used for backwards compatibility
    stateVersion = "24.11";

    packages = with pkgs; [
      dust
      eza
      fd
      httpie
      jq
      just
      # NOTE: nh does not support nix-darwin (only NixOS and Home Manager)
      nh
      # TODO: Can it be completely replaced with uv?
      pipx
      ripgrep
      sd
      tlrc
      tokei
      uv
    ];
  };

  # Let Home Manager install and manage itself
  # This option only works with a standalone Home Manager setup
  programs.home-manager.enable = true;
}
