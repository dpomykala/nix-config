{self, ...}: let
  hostName = "mbp-private";
in {
  flake.modules.darwin.${hostName} = {
    imports = with self.modules.darwin; [
      # Profiles
      base

      # Features
      "1password"
      "1password-ssh-agent"
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
      shell
      slack
      spotify
      the-unarchiver
      things
      utm
      vlc

      # User
      dp
    ];

    networking.hostName = hostName;

    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
