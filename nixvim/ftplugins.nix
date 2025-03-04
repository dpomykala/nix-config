/*
Custom ftplugins with configuration for specific file types.
*/
_: {
  files = {
    "after/ftplugin/gitcommit.lua" = {
      localOpts = {
        colorcolumn = [51 73];
        spell = true;
        textwidth = 72;
      };
    };

    "after/ftplugin/just.lua" = {
      localOpts = {
        tabstop = 4;
      };
    };

    "after/ftplugin/make.lua" = {
      localOpts = {
        # NOTE: `noexpandtab` is already set in the default ftplugin for make
        tabstop = 4;
      };
    };
  };
}
