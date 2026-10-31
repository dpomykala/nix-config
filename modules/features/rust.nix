_: {
  flake.modules.homeManager.rust = { lib, ... }: {
    programs.mise = {
      enable = lib.mkDefault true;

      globalConfig.tools.rust = {
        # rust-analyzer from the toolchain matches the compiler, and it needs
        # rust-src to read the standard library
        components = [
          "rust-analyzer"
          "rust-src"
        ];

        version = "latest";
      };
    };
  };
}
