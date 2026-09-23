_: {
  flake.modules.darwin.bear = { lib, ... }: {
    programs.mas = {
      enable = lib.mkDefault true;

      packages.Bear = 1091189122;
    };
  };
}
