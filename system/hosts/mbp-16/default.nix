{config, ...}: {
  imports = [
    ../../darwin
  ];

  # User owning the Homebrew prefix
  nix-homebrew.user = "${config.system.primaryUser}";

  nixpkgs.hostPlatform = "x86_64-darwin";

  system.primaryUser = "dp";
}
