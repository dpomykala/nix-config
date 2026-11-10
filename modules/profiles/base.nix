/*
  Base OS and Home Manager profile for all platforms.

  The Home Manager part holds only OS-independent configuration, because the
  platform profiles of every OS import it.
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

  flake.modules.homeManager.base = {
    imports =
      with self.modules.homeManager;
      [
        # Features
        fonts
        git
        home-manager
        sops
        xdg
      ]
      ++ [
        self.modules.generic.meta
        self.modules.generic.my-lib
      ];
  };
}
