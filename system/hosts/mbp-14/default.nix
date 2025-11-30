{config, ...}: {
  imports = [
    ../../darwin
    ./homebrew.nix
  ];

  networking.hostName = "mbp-14";

  # User owning the Homebrew prefix
  nix-homebrew.user = "${config.system.primaryUser}";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "dp";
}
