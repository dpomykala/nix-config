{ inputs, ... }: {
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    let
      # Use the custom Neovim (NixVim) configuration
      neovim = inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      home = {
        packages = [ neovim ];

        shellAliases.v = "nvim";
      };
    };
}
