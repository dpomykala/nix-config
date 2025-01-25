{pkgs, ...}: {
  imports = [
    ./core.nix
    ./homebrew.nix
    ./system.nix
  ];

  # System-wide packages
  environment.systemPackages = [
  ];

  programs.zsh = {
    # Do not call compinit in the system-wide config (/etc/zshrc)
    # Completion is enabled in Home Manger
    enableCompletion = false;

    # Disable the emulation support for Bash-like completions
    enableBashCompletion = false;
  };

  # Currently required for home-manager to work
  # See: https://github.com/nix-community/home-manager/issues/4026
  users.users.dp.home = "/Users/dp";
}
