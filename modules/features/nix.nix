_: {
  flake.modules.darwin.nix = { config, ... }: {
    nix.settings = {
      # Use new-style commands and flakes
      experimental-features = "nix-command flakes";

      # Sandbox all builds except the derivations that set `__noChroot`
      sandbox = "relaxed";

      # Let the primary user pass restricted options to the Nix daemon, such as
      # `--option sandbox false`
      trusted-users = [ config.system.primaryUser ];
    };
  };
}
