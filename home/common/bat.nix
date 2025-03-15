{self, ...}: {
  programs.bat = {
    enable = true;

    config = {
      theme = "Catppuccin Macchiato";
    };

    themes = {
      "Catppuccin Macchiato" = {
        src = self.inputs.bat-catppuccin-theme;
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };
}
