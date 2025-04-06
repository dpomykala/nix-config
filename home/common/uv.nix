{
  config,
  lib,
  pkgs,
  ...
}: {
  options.custom.uv = {
    tools = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        Tools to install with uv.

        Note that this is NOT fully reproducible! Different packages and even
        different Python interpreters may be used depending on installation
        time.

        Also note that tools will NOT be automatically uninstalled if they
        are removed from this list!
      '';
    };
  };

  config = {
    home = let
      localBin = "$HOME/.local/bin";
      script =
        # Add the local bin directory to PATH to avoid uv warnings
        ''
          export PATH=${localBin}:$PATH
        ''
        # Install each tool with uv
        # Use a Python interpreter managed by uv (download if needed)
        + lib.concatStringsSep "\n" (
          map (
            tool: ''
              run ${lib.getExe pkgs.uv} --managed-python tool install ${tool}
            ''
          )
          config.custom.uv.tools
        );
    in {
      packages = [pkgs.uv];

      # Make sure the local `bin` directory used by uv is in the PATH variable
      # NOTE: During activation, the final PATH variable is not yet set
      sessionPath = [localBin];

      activation.installUvTools = lib.mkIf (config.custom.uv.tools != []) (
        lib.hm.dag.entryAfter ["writeBoundary"] script
      );
    };
  };
}
