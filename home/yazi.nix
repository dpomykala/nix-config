{...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    # Mnemonic: "f" like "files" or "file manager"
    shellWrapperName = "f";
  };
}
