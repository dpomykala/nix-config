_: {
  flake.modules.homeManager.lua = { pkgs, ... }: {
    home.packages = with pkgs; [
      lua-language-server
      # Lua formatter
      stylua
    ];
  };
}
