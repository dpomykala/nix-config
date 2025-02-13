/**
  Custom ftplugins with configurtion for specific file types.
*/
{...}: {
  files."after/ftplugin/make.lua" = {
    localOpts = {
      # NOTE: `noexpandtab` is already set in the default ftplugin for make
      tabstop = 4;
    };
  };

  files."after/ftplugin/just.lua" = {
    localOpts = {
      tabstop = 4;
    };
  };
}
