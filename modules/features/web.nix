_: {
  flake.modules.homeManager.web = { pkgs, ... }: {
    home.packages = with pkgs; [
      # GraphQL language server, run as graphql-lsp
      graphql-language-service-cli
      # Strict HTML validation against the full spec
      superhtml
      tailwindcss-language-server
      # HTML, CSS, and JSON language servers from VS Code
      vscode-langservers-extracted
    ];
  };
}
