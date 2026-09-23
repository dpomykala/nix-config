_: {
  flake.modules.darwin.pages = { lib, ... }: {
    programs.mas = {
      enable = lib.mkDefault true;

      packages.Pages = 361309726;
    };
  };
}
