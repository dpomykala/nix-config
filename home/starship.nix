{ config, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Get editor completions based on the config schema
      "$schema" = "https://starship.rs/config-schema.json";

      character = {
        success_symbol = "[[󱜙](green) ❯](peach)";
        error_symbol = "[[󱚡](red) ❯](peach)";
        vimcmd_symbol = "[󱚣 ❮](subtext1)"; 
      };

      # Set the custom palette (defined below)
      palette = "catppuccin_macchiato";

      # Catppuccin Macchiato for Starship
      # https://github.com/catppuccin/starship
      palettes.catppuccin_macchiato = {
        rosewater = "#f4dbd6";
        flamingo = "#f0c6c6";
        pink = "#f5bde6";
        mauve = "#c6a0f6";
        red = "#ed8796";
        maroon = "#ee99a0";
        peach = "#f5a97f";
        yellow = "#eed49f";
        green = "#a6da95";
        teal = "#8bd5ca";
        sky = "#91d7e3";
        sapphire = "#7dc4e4";
        blue = "#8aadf4";
        lavender = "#b7bdf8";
        text = "#cad3f5";
        subtext1 = "#b8c0e0";
        subtext0 = "#a5adcb";
        overlay2 = "#939ab7";
        overlay1 = "#8087a2";
        overlay0 = "#6e738d";
        surface2 = "#5b6078";
        surface1 = "#494d64";
        surface0 = "#363a4f";
        base = "#24273a";
        mantle = "#1e2030";
        crust = "#181926";
      };
    };
  };
}
