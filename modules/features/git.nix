{ self, ... }: {
  flake.modules.homeManager.git =
    {
      config,
      lib,
      ...
    }:
    {
      imports =
        with self.modules.homeManager;
        [
          sops
        ]
        ++ [
          self.modules.generic.meta
        ];

      # Lazygit: https://github.com/jesseduffield/lazygit
      # Sets `lg` wrapper by default
      programs.lazygit.enable = true;

      programs.git = lib.mkMerge [
        {
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

          settings = lib.mkMerge [
            {
              # Use different colors for moved lines in a diff
              diff.colorMoved = true;

              init.defaultBranch = "main";

              merge.conflictstyle = "zdiff3";

              push.autoSetupRemote = true;

              user.name = config.meta.user.name;
            }
          ];
        }

        # Use an encrypted email (via an included config) if any
        (lib.mkIf (config.sops.secrets ? userEmail) {
          programs.git.includes = [
            {
              path = config.sops.templates.gitconfig-work-email.path;
            }
          ];

          sops.templates.gitconfig-work-email.content = ''
            [user]
              email = "${config.sops.placeholder.userEmail}"
          '';
        })

        # Use a public email if provided and there is no encrypted one
        (lib.mkIf (!(config.sops.secrets ? userEmail) && config.meta.user.email != null) {
          programs.git.settings.user.email = config.meta.user.email;
        })
      ];

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
    };
}
