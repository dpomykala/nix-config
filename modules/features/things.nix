_: {
  flake.modules.darwin.things = { lib, ... }: {
    programs.mas = {
      enable = lib.mkDefault true;

      packages.Things = 904280696;
    };
  };
}
