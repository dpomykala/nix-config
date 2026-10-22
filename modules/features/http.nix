_: {
  flake.modules.homeManager.http = { pkgs, ... }: {
    home.packages = with pkgs; [
      hurl
      posting
      xh
    ];
  };
}
