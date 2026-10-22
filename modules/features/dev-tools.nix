/*
  Development CLI tools that don't justify a feature of their own.

  A tool with its own configuration, or one that belongs to a capability such
  as `http`, goes in a feature for that capability instead.
*/
_: {
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      dust
      fd
      herdr
      hunk
      jq
      just
      nh
      pv
      ripgrep
      sd
      shellcheck
      tlrc
      tokei
      zstd
    ];
  };
}
