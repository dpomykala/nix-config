_: {
  imports = [
    ./zsh.nix
  ];

  # Aliases compatible across all shells
  # NOTE: Aliases relating to some tools are set in dedicated modules
  home.shellAliases = {
    # GENERAL

    # Clear the terminal output
    cl = "clear";

    # PYTHON

    py = "python";
    cl-pyc = "find ./ -name '*.pyc' -delete";

    # DOCKER

    dps = "docker ps";
    dcp = "docker-compose";
    cl-docker = "docker system prune --volumes -f";
  };
}
