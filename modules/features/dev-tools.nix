/*
  Development tools that don't justify a feature of their own, including the
  language servers, formatters, and linters of languages without a feature.

  A tool with its own configuration, or one that belongs to a capability such
  as `http`, goes in a feature for that capability instead.
*/
_: {
  flake.modules.homeManager.dev-tools =
    { pkgs, ... }:
    let
      # Language servers, formatters, and linters
      langTools = with pkgs; [
        # Markdown language server
        # TODO: Re-enable marksman when it is in the binary cache
        # marksman
        nginx-language-server
        # Formatter for web languages, Markdown, YAML, and TOML
        oxfmt
        # TOML language server
        tombi
        yaml-language-server
      ];
    in
    {
      home.packages =
        with pkgs;
        [
          dust
          fd
          hunk
          jq
          nh
          pv
          ripgrep
          sd
          tlrc
          tokei
          zstd
        ]
        ++ langTools;
    };
}
