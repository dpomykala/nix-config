_: {
  flake.modules.homeManager.git =
    {
      config,
      lib,
      ...
    }:
    {
      # Lazygit: https://github.com/jesseduffield/lazygit
      # Home Manager also adds the `lg` shell wrapper
      programs.lazygit.enable = true;

      programs.git = lib.mkMerge [
        {
          enable = true;

          ignores = [
            # macOS
            "._*"
            ".DS_Store"

            # Vim
            "*~"
            "*.swp"

            # Project-specific Neovim configuration (built-in, see `:h 'exrc'`)
            ".nvim.lua"
            ".nvimrc"
            ".exrc"

            # Project-local session for Neovim (mini.sessions)
            ".session.nvim"

            # Project-specific configuration for Helix
            ".helix"

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
            ".agent-work/"
            "CLAUDE.local.md"
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

            user.name = config.meta.user.fullName;
          };
        }

        /*
          Use the encrypted email, if the home has one, through an included
          config. `lib.mkBefore` renders the include first, so the includes of
          a home override it within their scope.
        */
        (lib.mkIf (config.sops.secrets ? userEmail) {
          includes = lib.mkBefore [
            { path = config.sops.templates.gitconfig-work-email.path; }
          ];
        })

        # Use the public email if there is one and no encrypted email
        (lib.mkIf (!(config.sops.secrets ? userEmail) && config.meta.user.email != null) {
          settings.user.email = config.meta.user.email;
        })
      ];

      sops.templates = lib.mkIf (config.sops.secrets ? userEmail) {
        gitconfig-work-email.content = ''
          [user]
            email = "${config.sops.placeholder.userEmail}"
        '';
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
        gd1 = "git diff HEAD~1";
        gd2 = "git diff HEAD~2";
        gds = "gd --staged";
        gds1 = "gd --staged HEAD~1";
        gds2 = "gd --staged HEAD~2";
        glg = "git log --graph";
        gll = "git log --oneline";
        gpl = "git pull";
        gps = "git push";
        grr = "git reset";
        grs = "gr --staged";
        gst = "git stash";
      };
    };
}
