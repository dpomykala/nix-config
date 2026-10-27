_: {
  flake.modules.homeManager.claude-code =
    { lib, pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;

        # Claude Code writes `/config` changes, permissions, and plugins to its
        # settings. Removing a setting here doesn't remove it from the settings
        # file, so delete it from ~/.claude/settings.json too.
        mutableSettings = true;

        # Workaround: the nixpkgs wrapper sets CLAUDE_CODE_CERT_STORE=system
        # (nixpkgs commit d1f1777), and on macOS that store lacks the built-in
        # root CAs, so every API request fails TLS verification. This restores
        # the upstream default on macOS and keeps the wrapper's choice on Linux.
        # It goes in the settings, not in a shell variable, because background
        # agents get most of their environment from the supervisor process,
        # not from the shell. Drop it when the upstream package is fixed.
        settings.env.CLAUDE_CODE_CERT_STORE = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "bundled,system";
      };
    };
}
