_: {
  programs.mise = {
    enable = true;

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
        python = "latest";
        rust = "latest";
        zig = "latest";
      };
    };
  };
}
