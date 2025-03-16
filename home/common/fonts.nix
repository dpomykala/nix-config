{pkgs, ...}: {
  # Automatically detect fonts installed through `home.packages`
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];
}
