{ pkgs, ...}: {
  imports = [
    ./bat.nix
    ./fzf.nix
    ./git.nix
    ./mise.nix
    ./ssh.nix
    ./starship.nix
    ./thefuck.nix
    ./vim
    ./wezterm
    ./zoxide.nix
    ./zsh
  ];

  # The version used for backwards compatibility
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.dust
    pkgs.eza
    pkgs.fd
    pkgs.httpie
    pkgs.jq
    # TODO: Can it be completely replaced with uv?
    pkgs.pipx
    pkgs.ripgrep
    pkgs.sd
    pkgs.tlrc
    pkgs.tokei
    pkgs.uv
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
