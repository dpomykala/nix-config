/*
  The mise tool manager. Language features add their runtimes and the tools
  that must match them to `programs.mise.globalConfig.tools`.

  Home Manager only writes the mise config, so the activation step installs the
  missing tools. A failure only warns, so a network problem doesn't block a
  switch.
*/
_: {
  flake.modules.homeManager.mise =
    { config, lib, ... }:
    {
      # Run after `linkGeneration`, so mise reads the new config
      home.activation.miseInstall = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        run ${lib.getExe config.programs.mise.package} install \
          || warnEcho "mise install failed, run it manually"
      '';

      programs.mise = {
        enable = true;

        mutableSettings = true;

        globalConfig.settings = {
          # Load environment variables from dotenv files
          env_file = ".env";
        };
      };
    };
}
