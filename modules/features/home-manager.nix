_: {
  flake.modules.homeManager.home-manager = {
    # The version used for backwards compatibility
    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself
    # NOTE: This option only works with a standalone Home Manager setup
    programs.home-manager.enable = true;
  };
}
