_: {
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      dust
      fd
      glab
      # hunk
      jq
      just
      nh
      pv
      ripgrep
      sd
      tlrc
      tokei
      zstd
    ];
  };
}
