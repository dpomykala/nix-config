_: {
  flake.modules.darwin.nix = { config, ... }: {
    nix.settings = {
      # Use new-style commands and flakes
      experimental-features = "nix-command flakes";

      # Sandbox all builds, which Nix doesn't do by default on macOS
      sandbox = true;

      # Let the primary user pass restricted options to the Nix daemon, such as
      # `--option sandbox false`
      trusted-users = [ config.system.primaryUser ];
    };
  };
}
