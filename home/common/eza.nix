{pkgs, ...}: {
  home = {
    packages = [pkgs.eza];

    shellAliases = {
      # Use eza (with some defaults) instead of ls and tree
      ls = "eza --icons --hyperlink --group-directories-first";
      ll = "ls --long --all --time-style=long-iso --git";
      lt = ''ll --tree --ignore-glob ".git"'';
      tree = "ls --tree --level 3";
    };
  };
}
