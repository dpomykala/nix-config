{self, ...}: {
  programs.bat = let
    theme = "Catppuccin Macchiato";
  in {
    enable = true;

    config.theme = theme;

    syntaxes.just = {
      src = self.inputs.just-sublime;
      file = "Syntax/Just.sublime-syntax";
    };

    themes."${theme}" = {
      src = self.inputs.bat-catppuccin-theme;
      file = "themes/${theme}.tmTheme";
    };
  };

  # Use bat instead of cat
  home.shellAliases.cat = "bat";
}
