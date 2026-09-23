_: {
  # TODO: Move to the development profile?
  flake.modules.homeManager.packages = { pkgs, ... }: {
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
      tlrc
      tokei
      zstd
    ];
  };
}
