{ self, ... }:
let
  hostName = "mbp-private";
  system = "aarch64-darwin";
in
{
  flake.modules.darwin.${hostName} = {
    imports =
      with self.modules.darwin;
      [
        # Profiles
        base
        development

        # Features
        bear
        brave-browser
        jetbrains-toolbox
        karabiner
        logi-options-plus
        notion
        numbers
        nvidia-geforce-now
        obsidian
        pages
        raycast
        slack
        spotify
        the-unarchiver
        things
        utm
        vlc

        # User
        dp
      ]
      ++ [
        # Features
        self.modules.darwin."1password"
      ];

    networking.hostName = hostName;

    nixpkgs.hostPlatform = system;

    # Required by flake-parts' moduleWithSystem to determine the system
    # without config.nixpkgs.pkgs (which would cause infinite recursion)
    _module.args = { inherit system; };
  };
}
