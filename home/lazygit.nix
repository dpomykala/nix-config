/*
Lazygit: https://github.com/jesseduffield/lazygit
*/
{
  config,
  lib,
  ...
}: {
  programs.lazygit = {
    enable = true;

    settings =
      {}
      // lib.optionalAttrs config.programs.git.delta.enable {
        # Use delta as a diff pager
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --line-numbers";
        };
      };
  };
}
