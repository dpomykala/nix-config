{
  config,
  lib,
  self,
  ...
}: let
  deltaCatppuccinFlavor = "catppuccin-macchiato";
in {
  programs.git = {
    enable = true;

    aliases = lib.optionalAttrs config.programs.git.delta.enable {
      # Show a side-by-side diff in delta
      diffs = lib.concatStringsSep " " [
        "-c delta.features='${deltaCatppuccinFlavor} defaults side-by-side'"
        "diff"
      ];
    };

    extraConfig = {
      # Use different colors for moved lines in a diff
      diff.colorMoved = true;

      init.defaultBranch = "main";

      merge.conflictstyle = "zdiff3";

      push.autoSetupRemote = true;
    };

    # Globally ignored paths
    ignores = [
      # MacOS
      "._*"
      ".DS_Store"

      # Vim
      "*~"
      "*.swp"

      # Project specific configuration for Neovim (neoconf.nvim)
      ".neoconf.json"
      # Project specific configuration for Neovim (built-in, see `:h 'exrc'`)
      ".nvim.lua"
      ".nvimrc"
      ".exrc"

      # JetBrains IDEs
      ".idea"

      # Python
      "*.pyc"
      ".venv"
      "venv"

      # Node.js
      "node_modules"

      # General
      "*.log"
    ];

    includes = lib.optionals config.programs.git.delta.enable [
      # Catppuccin theme for delta
      {path = "${self.inputs.delta-catppuccin-theme}/catppuccin.gitconfig";}
    ];

    # Configuration for 3rd party tools (integrations)

    # https://github.com/dandavison/delta
    delta = {
      enable = true;

      options = {
        features = "${deltaCatppuccinFlavor} defaults";

        # Specify default options as a "feature"
        # Features can be overridden from a cmd line with --features
        defaults = {
          line-numbers = true;
          navigate = true;
        };
      };
    };
  };
}
