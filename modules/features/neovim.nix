{ inputs, ... }: {
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    let
      # The NixVim configuration without language servers and formatters,
      # because the language features install them
      neovim = inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.external;
    in
    {
      home = {
        packages = [ neovim ];

        shellAliases.v = "nvim";
      };
    };
}
