/*
  JavaScript and TypeScript: the Node.js and Bun runtimes, and the tools for
  both languages.
*/
_: {
  flake.modules.homeManager.javascript = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      # Linter, with its own language server
      oxlint
      # TypeScript language server, for navigation and type errors
      vtsls
    ];

    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools = {
        bun = "latest";
        node = "latest";
      };
    };
  };
}
