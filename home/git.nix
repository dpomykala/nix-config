{
  config,
  lib,
  self,
  ...
}: {
  programs.git = {
    enable = true;

    aliases = lib.optionalAttrs config.programs.git.delta.enable {
      # Show a side-by-side diff in delta
      diffs = "-c delta.features='catppuccin-macchiato side-by-side' diff";
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

    # To specify different Git identity (e.g. for work) add to `includes`:
    # {
    #   condition = "hasconfig:remote.*.url:git@git.example-company.com/**";
    #   contents.user.email = "me@example-company.com";
    # }
    includes = lib.optionals config.programs.git.delta.enable [
      # Theme for delta
      {path = "${self.inputs.delta-catppuccin-theme}/catppuccin.gitconfig";}
    ];

    # TODO: Do not hardcode user-specific data?
    userName = "Damian Pomykała";
    userEmail = "168227269+dpomykala@users.noreply.github.com";

    # Configuration for 3rd party tools (integrations)

    # https://github.com/dandavison/delta
    delta = {
      enable = true;

      options = {
        features = "catppuccin-macchiato";
        line-numbers = true;
        navigate = true;
      };
    };
  };

  # https://github.com/jesseduffield/lazygit
  programs.lazygit = {
    enable = true;

    settings = {
      # Use delta as a diff pager
      # NOTE: Requires delta to be installed
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers";
      };
    };
  };
}
