_: {
  flake.modules.homeManager.spelling = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Spelling and grammar of English prose, such as Markdown and commits
      harper
      # Known misspellings in code, including identifiers
      typos-lsp
    ];
  };
}
