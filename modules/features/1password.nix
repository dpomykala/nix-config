_: {
  flake.modules.darwin."1password" = { lib, ... }: {
    homebrew.casks = [ "1password" ];

    programs.mas = {
      enable = lib.mkDefault true;

      packages."1Password for Safari" = 1569813296;
    };
  };
}
