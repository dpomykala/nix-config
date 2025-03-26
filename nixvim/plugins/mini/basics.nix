_: {
  plugins.mini = {
    modules.basics = {
      # Manage options manually
      options.basic = false;

      /*
      Set additional mappings for handling windows:
      - <C-jhkl> for window navigation
      - <C-arrow> for window resizing
      */
      mappings.windows = true;
    };

    # Disable gO/go mappings - can be replaced with built-in [ / ] + <Space>
    luaConfig.post =
      # Lua
      ''
        vim.keymap.del("n", "gO")
        vim.keymap.del("n", "go")
      '';
  };
}
