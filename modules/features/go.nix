_: {
  flake.modules.homeManager.go = { lib, pkgs, ... }: {
    # golangci-lint-langserver only runs golangci-lint, so any version works
    home.packages = [ pkgs.golangci-lint-langserver ];

    programs.mise = {
      enable = lib.mkDefault true;

      /*
        gopls and golangci-lint support only the Go versions up to the one that
        built them. mise builds gopls with this Go, and golangci-lint releases
        follow new Go releases.
      */
      globalConfig.tools = {
        go = "latest";
        "go:golang.org/x/tools/gopls" = "latest";
        golangci-lint = "latest";
      };
    };
  };
}
