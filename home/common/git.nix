_: {
  programs.git = {
    enable = true;

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

      # Project local session for Neovim (mini.sessions)
      ".session.nvim"

      # JetBrains IDEs
      ".idea"

      # Python
      "*.pyc"
      ".venv"
      "venv"

      # Node.js
      "node_modules"

      # Env files
      ".env"
      ".env.local"

      # Tools
      "mise.local.toml"

      # General
      "*.log"
    ];

    settings = {
      # Use different colors for moved lines in a diff
      diff.colorMoved = true;

      init.defaultBranch = "main";

      merge.conflictstyle = "zdiff3";

      push.autoSetupRemote = true;
    };
  };

  home.shellAliases = {
    ga = "git add";
    gb = "git branch";
    gc = "git checkout";
    gd = "git diff";
    gf = "git fetch";
    gl = "git log";
    gr = "git restore";
    gs = "git status";
    gcm = "git commit";
    gds = "gd --staged";
    glg = "git log --graph";
    gll = "git log --oneline";
    gpl = "git pull";
    gps = "git push";
    grr = "git reset";
    grs = "gr --staged";
    gst = "git stash";
  };
}
