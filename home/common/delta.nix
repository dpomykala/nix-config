/*
Delta: https://github.com/dandavison/delta
*/
{
  lib,
  self,
  ...
}: let
  deltaCatppuccinFlavor = "catppuccin-macchiato";
in {
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;

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

    git = {
      includes = [
        # Catppuccin theme for delta
        {path = "${self.inputs.delta-catppuccin-theme}/catppuccin.gitconfig";}
      ];

      settings.alias = {
        # Show a side-by-side diff in delta
        diffs = lib.concatStringsSep " " [
          "-c delta.features='${deltaCatppuccinFlavor} defaults side-by-side'"
          "diff"
        ];
      };
    };

    lazygit.settings = {
      # Use delta as a diff pager in Lazygit
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers";
      };
    };
  };
}
