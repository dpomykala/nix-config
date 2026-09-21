{ inputs, ... }: {
  flake.modules.homeManager.nixgl = {
    # Enable support for OpenGL on non-NixOS Linux distributions
    # NOTE: You must also wrap specific packages that need OpenGL
    nixGL.packages = inputs.nixGL.packages;
  };
}
