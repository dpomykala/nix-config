{pkgs, ...}: {
  programs.bat = {
    enable = true;

    config = {
      theme = "catppuccin_macchiato";
    };

    themes = {
      catppuccin_macchiato = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
          sha256 = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
        };
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };
}
