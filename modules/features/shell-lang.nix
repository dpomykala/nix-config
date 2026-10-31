_: {
  flake.modules.homeManager.shell-lang = { pkgs, ... }: {
    # bash-language-server runs shellcheck and shfmt from PATH
    home.packages = with pkgs; [
      bash-language-server
      shellcheck
      shfmt
    ];
  };
}
