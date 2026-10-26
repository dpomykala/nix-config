_: {
  flake.modules.homeManager.helix = {
    programs.helix = {
      enable = true;

      settings = {
        editor.line-number = "relative";

        theme = "catppuccin_macchiato";
      };
    };
  };
}
