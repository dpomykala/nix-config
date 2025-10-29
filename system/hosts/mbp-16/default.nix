{config, ...}: {
  imports = [
    ../../darwin
  ];

  networking.hostName = "mbp-16";

  # User owning the Homebrew prefix
  nix-homebrew.user = "${config.system.primaryUser}";

  nixpkgs.hostPlatform = "x86_64-darwin";

  system.primaryUser = "dp";
}
