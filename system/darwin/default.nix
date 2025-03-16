_: {
  imports = [
    ./homebrew.nix
    ./nix.nix
    ./system.nix
  ];

  # System-wide packages
  environment.systemPackages = [];

  programs.zsh = {
    # Do not call compinit in the system-wide config (/etc/zshrc)
    # Completion is enabled in Home Manger
    enableCompletion = false;

    # Disable the emulation support for Bash-like completions
    enableBashCompletion = false;
  };
}
