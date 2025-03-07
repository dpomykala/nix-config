{inputs}: {
  # Use the latest version of blink.cmp from the main branch
  blink-cmp-main = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
        inherit (inputs.blink-cmp.packages.${prev.system}) blink-cmp;
      };
  };

  neovim-nightly = final: prev: {
    neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${prev.system}.default;
  };
}
