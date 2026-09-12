{self, ...}: let
  hostName = "mbp-positive";
in {
  flake.modules.darwin.${hostName} = {
    imports = with self.modules.darwin; [
      # Profiles
      base

      # Features
      "1password"
      "1password-ssh-agent"
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
    ];

    networking.hostName = hostName;

    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
