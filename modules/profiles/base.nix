/*
  Base OS and Home Manager profile for all platforms.

  For Home Manager, this should contain OS-independent configuration only.
*/
{ self, ... }: {
  flake.modules.darwin.base = {
    imports =
      with self.modules.darwin;
      [
        # Features
        homebrew
        nix
        nixpkgs
        system
      ]
      ++ [
        self.modules.generic.meta
        self.modules.generic.my-lib
      ];
  };

  # OS-independent config only!
  flake.modules.homeManager.base = {
    imports =
      with self.modules.homeManager;
      [
        # Features
        fonts
        git
        home-manager
        packages
        sops
        xdg
      ]
      ++ [
        self.modules.generic.meta
        self.modules.generic.my-lib
      ];
  };
}
