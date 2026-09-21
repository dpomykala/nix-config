_: {
  flake.modules.homeManager.ai = { pkgs, ... }: {
    home.packages = with pkgs; [
      codegraph
      ollama
      pi-coding-agent
      rtk
    ];
  };
}
