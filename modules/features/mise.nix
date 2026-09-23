_: {
  flake.modules.homeManager.mise = {
    programs.mise = {
      enable = true;

      enableMutableConfig = true;

      globalConfig = {
        settings = {
          # Load environment variables from dotenv files
          env_file = ".env";
        };

        tools = {
          bun = "latest";
          elixir = "latest";
          erlang = "latest";
          go = "latest";
          node = "latest";
          rust = "latest";
          zig = "latest";
        };
      };
    };
  };
}
