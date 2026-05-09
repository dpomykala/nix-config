{config, ...}: {
  imports = [
    ../../darwin
    ./homebrew.nix
  ];

  networking.hostName = "mbp-private";

  # User owning the Homebrew prefix
  nix-homebrew.user = "${config.system.primaryUser}";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "dp";
}
