{...}: {
  programs.zsh.shellAliases = {
    # GENERAL

    # Clear the terminal output
    cl = "clear";

    # Use eza (with some defaults) instead of ls and tree
    ls = "eza --icons --hyperlink --group-directories-first";
    ll = "ls --long --all --time-style=long-iso --git";
    lt = ''ll --tree --ignore-glob ".git"'';
    tree = "ls --tree --level 3";

    # Use bat instead of cat
    cat = "bat";

    # APPLICATIONS

    v = "vim";

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
    gr = "git reset";
    gs = "git status";
    gcm = "git commit";
    gds = "gd --staged";
    glg = "git log --graph";
    gll = "git log --oneline";
    gpl = "git pull";
    gps = "git push";
    gst = "git stash";

    # DOCKER

    dps = "docker ps";
    dcp = "docker-compose";
    cl-docker = "docker system prune --volumes -f";
  };
}
