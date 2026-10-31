_: {
  flake.modules.homeManager.web = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Strict HTML validation against the full spec
      superhtml
      tailwindcss-language-server
      # HTML, CSS, and JSON language servers from VS Code
      vscode-langservers-extracted
    ];
  };
}
