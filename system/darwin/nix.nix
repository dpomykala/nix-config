_: {
  nix.settings = {
    # Use new-style commands and flakes
    experimental-features = "nix-command flakes";

    # Use a sandboxed environment for builds
    sandbox = true;
  };
}
