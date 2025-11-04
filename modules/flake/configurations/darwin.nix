/*
Darwin system configurations.
*/
{
  inputs,
  self,
  ...
}: {
  flake.darwinConfigurations = {
    # NOTE: Names should match the `scutil --get LocalHostName` command output

    "mbp-16" = inputs.nix-darwin.lib.darwinSystem {
      modules = [(self + "/system/hosts/mbp-16")];
      specialArgs = {inherit self;};
    };
  };
}
