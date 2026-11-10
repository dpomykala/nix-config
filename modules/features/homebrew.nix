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
          # Uninstall unlisted formulae and casks, and delete their app data
          # WARN: Doesn't remove Mac App Store apps, see `programs.mas.cleanup`
          cleanup = "zap";

          # Upgrade outdated formulae and casks during nix-darwin activation
          # Casks that update themselves or have no version stay as they are
          upgrade = true;
        };

        # List the taps of nix-homebrew, so that nix-darwin doesn't untap them
        # See https://github.com/zhaofengli/nix-homebrew/issues/5
        taps = builtins.attrNames config.nix-homebrew.taps;
      };

      nix-homebrew = {
        # Install Homebrew under the default prefix
        enable = true;

        # Allow only the taps that this configuration declares
        mutableTaps = false;

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
