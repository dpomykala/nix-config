/*
Configuration common to all Linux hosts other than NixOS.
*/
{self, ...}: {
  imports = [
    ../common
    ./wezterm.nix
  ];

  # Enable support for OpenGL on non-NixOS Linux distributions
  # NOTE: You must also wrap specific packages that need OpenGL
  nixGL.packages = self.inputs.nixGL.packages;

  # Enable better support for non-NixOS Linux distributions
  targets.genericLinux.enable = true;
}
