{ ... }: {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    globalConfig = {
      tools = {
        python = "latest";
        elixir = "latest";
        erlang = "latest";
      };

      # FIXME: Use programs.mise.settings instead?
      # See: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mise.settings
      settings = {
        # Load environment variables from dotenv files  
        env_file = ".env";
      };
    };
  };
}
