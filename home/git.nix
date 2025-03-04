_: {
  programs.git = {
    enable = true;

    # TODO: Do not hardcode user-specific data?
    userName = "Damian Pomykała";
    userEmail = "168227269+dpomykala@users.noreply.github.com";

    # Specify different Git identity for work
    #includes = [
    #  {
    #    condition = "hasconfig:remote.*.url:git@git.example-company.com/**";
    #    contents.user.email = "me@example-company.com";
    #  }
    #];

    extraConfig = {
      init.defaultBranch = "main";

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
  };
}
