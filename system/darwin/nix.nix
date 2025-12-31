{config, ...}: {
  nix.settings = {
    # Use new-style commands and flakes
    experimental-features = "nix-command flakes";

    # Use a sandboxed environment for builds
    sandbox = true;

    # Specify users having additional rights when connecting to the Nix daemon
    # This allows the use of restricted options, e.g. `--option sandbox false`
    trusted-users = [config.system.primaryUser];
  };
}
