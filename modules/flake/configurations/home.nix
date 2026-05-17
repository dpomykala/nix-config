/*
Standalone Home Manager configurations.
*/
{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations = {
    # NOTE: Hostnames should match the `hostname` command output

    "dp@mbp-private" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@mbp-private")];
      pkgs = inputs.nixpkgs.legacyPackages."aarch64-darwin";
    };

    "dp@mbp-positive" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@mbp-positive")];
      pkgs = inputs.nixpkgs.legacyPackages."aarch64-darwin";
    };

    "dp@vm-ubuntu" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@vm-ubuntu.nix")];
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    };
  };
}
