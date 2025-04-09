/*
render-markdown.nvim - Plugin to improve viewing Markdown files in Neovim.

https://nix-community.github.io/nixvim/plugins/render-markdown
https://github.com/MeanderingProgrammer/render-markdown.nvim
*/
_: {
  plugins.render-markdown = {
    enable = true;

    settings = {
      completions.lsp.enabled = true;

      file_types = ["Avante" "codecompanion" "markdown"];
    };
  };
}
