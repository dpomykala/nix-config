_: {
  programs.zsh.shellAliases = {
    # GENERAL

    # Clear the terminal output
    cl = "clear";

    # APPLICATIONS

    # Use bat instead of cat
    cat = "bat";

    # Use eza (with some defaults) instead of ls and tree
    ls = "eza --icons --hyperlink --group-directories-first";
    ll = "ls --long --all --time-style=long-iso --git";
    lt = ''ll --tree --ignore-glob ".git"'';
    tree = "ls --tree --level 3";

    # Open the default editor (either Vim or Neovim)
    v = "\${EDITOR:-vim}";

    # PYTHON

    py = "python";
    cl-pyc = "find ./ -name '*.pyc' -delete";

    # GIT

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

    # DOCKER

    dps = "docker ps";
    dcp = "docker-compose";
    cl-docker = "docker system prune --volumes -f";
  };
}
