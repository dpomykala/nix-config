{ inputs, ... }: {
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    let
      # Use the custom Neovim (NixVim) configuration. The language features
      # install the language servers and formatters, so it doesn't bundle them.
      neovim = inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.external;
    in
    {
      home = {
        packages = [ neovim ];

        shellAliases.v = "nvim";
      };
    };
}
