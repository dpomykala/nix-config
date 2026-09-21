{ lib, ... }: {
  options.flake.factory = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
  };
}
