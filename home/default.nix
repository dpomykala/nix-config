{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git.nix
    ./mise.nix
    ./nvim.nix
    # FIXME: MacOS specific?
    ./ssh.nix
    ./starship.nix
    ./thefuck.nix
    ./vim
    ./wezterm
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

    packages = [
      pkgs.dust
      pkgs.eza
      pkgs.fd
      pkgs.httpie
      pkgs.jq
      pkgs.just
      # NOTE: nh does not support nix-darwin (only NixOS and Home Manager)
      pkgs.nh
      # TODO: Can it be completely replaced with uv?
      pkgs.pipx
      pkgs.ripgrep
      pkgs.sd
      pkgs.tlrc
      pkgs.tokei
      pkgs.uv
    ];
  };

  # Let Home Manager install and manage itself
  # This option only works with a standalone Home Manager setup
  programs.home-manager.enable = true;
}
