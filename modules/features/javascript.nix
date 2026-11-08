/*
  JavaScript and TypeScript: the Node.js and Bun runtimes, and the tools for
  both languages.
*/
_: {
  flake.modules.homeManager.javascript = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      # Linter, with its own language server
      # TODO: Replace the override with plain `oxlint` once nixpkgs fixes it
      (oxlint.overrideAttrs (old: {
        # shortcut: nixpkgs redirects only `/bin/ps`, but napi-rs cli also
        # runs `ioreg` and `sysctl`, which the Darwin sandbox denies with
        # EPERM. A missing path fails softly and napi-rs skips its lock.
        preBuild =
          old.preBuild
          + lib.optionalString stdenv.hostPlatform.isDarwin ''
            substituteInPlace node_modules/.pnpm/@napi-rs+cli@*/node_modules/@napi-rs/cli/dist/cli.js \
              --replace-fail '"/usr/sbin/ioreg"' '"/nonexistent"' \
              --replace-fail '"/usr/sbin/sysctl"' '"/nonexistent"'
          '';
      }))
      # TypeScript language server, for navigation and type errors
      vtsls
    ];

    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools = {
        bun = "latest";
        node = "latest";
      };
    };
  };
}
