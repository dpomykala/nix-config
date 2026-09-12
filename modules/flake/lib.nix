{ self, ... }: {
  # Expose the custom lib as a flake output
  flake.lib.my = import self + "/lib";
}
