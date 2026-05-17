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

    "mbp-private" = inputs.nix-darwin.lib.darwinSystem {
      modules = [(self + "/system/hosts/mbp-private")];
      specialArgs = {inherit self;};
    };

    "mbp-positive" = inputs.nix-darwin.lib.darwinSystem {
      modules = [(self + "/system/hosts/mbp-positive")];
      specialArgs = {inherit self;};
    };
  };
}
