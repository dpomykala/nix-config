_: {
  flake.modules.homeManager.home-manager = {
    # The version used for backwards compatibility
    home.stateVersion = "26.05";

    # Let Home Manager install and manage itself (standalone setup only)
    programs.home-manager.enable = true;
  };
}
