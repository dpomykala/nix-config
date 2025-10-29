_: {
  programs.zoxide = {
    enable = true;

    # Options to pass when calling zoxide init
    options = [
      # Replace the builtin cd command with the zoxide version
      # Add also the cdi command for the interactive selection
      "--cmd cd"
    ];
  };
}
