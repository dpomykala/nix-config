_: {
  flake.modules.darwin.numbers = { lib, ... }: {
    programs.mas = {
      enable = lib.mkDefault true;

      packages.Numbers = 361304891;
    };
  };
}
