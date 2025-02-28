{lib, ...}: {
  diagnostics = {
    float = {border = "rounded";};
    severity_sort = true;
    signs = {
      text = lib.nixvim.toRawKeys {
        "vim.diagnostic.severity.ERROR" = " ";
        "vim.diagnostic.severity.WARN" = " ";
        "vim.diagnostic.severity.INFO" = " ";
        "vim.diagnostic.severity.HINT" = " ";
      };
    };
    virtual_text = {
      prefix = "■";
      spacing = 4;
    };
  };
}
