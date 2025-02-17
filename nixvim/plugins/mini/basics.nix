{...}: {
  plugins.mini.modules.basics = {
    # Manage options manually
    options.basic = false;

    /*
    Set additional mappings for handling windows:
    - <C-jhkl> for window navigation
    - <C-arrow> for window resizing
    */
    mappings.windows = true;
  };
}
