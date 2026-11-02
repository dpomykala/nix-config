_: {
  flake.modules.homeManager.elixir = { lib, pkgs, ... }: {
    home.packages = [
      # Official Elixir language server. It builds its engine with the Elixir
      # of each project, so any version works.
      pkgs.beamPackages.expert
    ];

    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools = {
        elixir = "latest";
        erlang = "latest";
      };
    };
  };
}
