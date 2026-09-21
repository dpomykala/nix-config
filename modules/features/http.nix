_: {
  flake.modules.homeManager.http = { pkgs, ... }: {
    home.packages = with pkgs; [
      httpie
      hurl
      posting
    ];
  };
}
