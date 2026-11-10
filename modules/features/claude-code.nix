_: {
  flake.modules.homeManager.claude-code =
    { lib, pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;

        /*
          Claude Code writes `/config` changes, permissions, and plugins to its
          settings. Removing a setting here doesn't remove it from the settings
          file, so delete it from `~/.claude/settings.json` too.
        */
        mutableSettings = true;

        /*
          The nixpkgs wrapper trusts only the system store, which on macOS
          lacks the root CAs. It adds the Nix bundle from `NIX_SSL_CERT_FILE`,
          but GUI launches and background agents can start without that
          variable. Pinning the bundle here also keeps the wrapper's choice to
          skip the roots bundled in Claude Code, which don't follow cacert
          updates.
        */
        settings.env.NODE_EXTRA_CA_CERTS = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      };
    };
}
