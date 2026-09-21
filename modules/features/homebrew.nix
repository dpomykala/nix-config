{ inputs, ... }: {
  flake.modules.darwin.homebrew =
    { config, ... }:
    let
      inherit (inputs)
        homebrew-bundle
        homebrew-cask
        homebrew-core
        nix-homebrew
        ;
    in
    {
      imports = [
        nix-homebrew.darwinModules.nix-homebrew
      ];

      homebrew = {
        enable = true;

        onActivation = {
          # Remove all formulae/casks not listed in this configuration
          # WARN: DOES NOT work for applications installed via `masApps`
          cleanup = "zap";

          # Upgrade outdated formulae/casks during nix-darwin activation
          # NOTE: Unversioned/auto-update casks won't be upgraded by default
          upgrade = true;
        };

        # Specify the same taps as those managed by nix-homebrew
        # This prevents nix-darwin from trying to untap all taps
        # See: https://github.com/zhaofengli/nix-homebrew/issues/5
        taps = builtins.attrNames config.nix-homebrew.taps;
      };

      nix-homebrew = {
        # Install Homebrew under the default prefix
        enable = true;

        # Enable fully-declarative tap management
        # Only taps declared in this configuration are allowed
        mutableTaps = false;

        # Use declarative tap management
        taps = {
          "homebrew/homebrew-bundle" = homebrew-bundle;
          "homebrew/homebrew-cask" = homebrew-cask;
          "homebrew/homebrew-core" = homebrew-core;
        };

        # User owning the Homebrew prefix
        user = "${config.system.primaryUser}";
      };
    };
}
