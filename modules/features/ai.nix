_: {
  flake.modules.homeManager.ai = { pkgs, ... }: {
    home.packages = with pkgs; [
      ollama
      pi-coding-agent
    ];
  };
}
