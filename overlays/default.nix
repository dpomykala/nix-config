{inputs}: {
  # The latest version of blink.cmp from the main branch
  blink-cmp-main = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        inherit (inputs.blink-cmp.packages.${prev.system}) blink-cmp;
      };
  };

  # The latest version of snacks.nvim from the main branch
  snacks-nvim-main = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        snacks-nvim = prev.vimUtils.buildVimPlugin {
          pname = "snacks.nvim";
          src = inputs.snacks-nvim;
          version = inputs.snacks-nvim.shortRev;

          # Skip the "require" check for these Lua modueles
          nvimSkipModule = [
            "trouble.sources.profiler"
            "snacks.dashboard"
            "snacks.indent"
            "snacks.git"
            "snacks.picker.core.list"
            "snacks.picker.util.db"
            "snacks.picker.config.highlights"
            "snacks.terminal"
            "snacks.win"
            "snacks.scratch"
            "snacks.image.init"
            "snacks.image.placement"
            "snacks.image.convert"
            "snacks.image.image"
            "snacks.dim"
            "snacks.notifier"
            "snacks.words"
            "snacks.input"
            "snacks.scroll"
            "snacks.lazygit"
            "snacks.zen"
          ];
        };
      };
  };

  neovim-nightly = final: prev: {
    neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
  };
}
