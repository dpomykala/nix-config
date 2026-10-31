_: {
  flake.modules.homeManager.elixir = { lib, pkgs, ... }: {
    home.packages = [
      # Official Elixir language server
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
