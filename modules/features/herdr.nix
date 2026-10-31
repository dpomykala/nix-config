_: {
  flake.modules.homeManager.herdr = {
    home.shellAliases.hr = "herdr";

    programs.herdr = {
      enable = true;

      # Herdr writes onboarding choices and settings UI changes to its config.
      # Removing a setting here doesn't remove it from the config file, so
      # delete it from ~/.config/herdr/config.toml too.
      mutableSettings = true;

      settings = {
        # Herdr has no Catppuccin Macchiato theme, so these overrides replace
        # the colors of the default Catppuccin Mocha theme. Drop them when
        # Herdr ships an official Macchiato theme.
        theme.custom = {
          accent = "#8aadf4";
          active_row_bg = "#24273a";
          blue = "#8aadf4";
          green = "#a6da95";
          mauve = "#c6a0f6";
          overlay0 = "#6e738d";
          overlay1 = "#8087a2";
          panel_bg = "#1e2030";
          peach = "#f5a97f";
          red = "#ed8796";
          selection_bg = "#363a4f";
          subtext0 = "#a5adcb";
          surface0 = "#363a4f";
          surface1 = "#494d64";
          surface_dim = "#24273a";
          teal = "#8bd5ca";
          text = "#cad3f5";
          yellow = "#eed49f";
        };

        # Nix pins the version, so the update check only shows noise
        update.version_check = false;
      };
    };
  };
}
