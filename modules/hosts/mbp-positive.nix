{ self, ... }:
let
  hostName = "mbp-positive";
  system = "aarch64-darwin";
in
{
  flake.modules.darwin.${hostName} = {
    imports =
      with self.modules.darwin;
      [
        # Profiles
        base

        # Features
        brave-browser
        jetbrains-toolbox
        karabiner
        logi-options-plus
        notion
        numbers
        obsidian
        pages
        raycast
        shell
        slack
        the-unarchiver

        # User
        dp
      ]
      ++ [
        # Features
        self.modules.darwin."1password"
        self.modules.darwin."1password-ssh-agent"
      ];

    networking.hostName = hostName;

    nixpkgs.hostPlatform = system;

    # Required by flake-parts' moduleWithSystem to determine the system
    # without config.nixpkgs.pkgs (which would cause infinite recursion)
    _module.args = { inherit system; };
  };
}
