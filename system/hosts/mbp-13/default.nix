_: {
  imports = [
    ../../darwin
  ];

  # User owning the Homebrew prefix
  # NOTE: nix-homebrew options are provided by the flake input
  nix-homebrew.user = "dp";

  nixpkgs.hostPlatform = "x86_64-darwin";
}
