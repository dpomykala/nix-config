_: {
  flake.modules.darwin.nix = { config, ... }: {
    nix.settings = {
      # Use new-style commands and flakes
      experimental-features = "nix-command flakes";

      # Use a sandboxed environment for builds ("relaxed" allows derivations
      # that set `__noChroot`, e.g. claude-code, to build without sandboxing)
      sandbox = "relaxed";

      # Specify users having additional rights when connecting to the Nix daemon
      # This allows the use of restricted options, e.g. `--option sandbox false`
      trusted-users = [ config.system.primaryUser ];
    };
  };
}
