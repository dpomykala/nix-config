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

    "dp@mbp-16" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@mbp-16")];
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-darwin";
    };

    "dp@mbp-14" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@mbp-14")];
      pkgs = inputs.nixpkgs.legacyPackages."aarch64-darwin";
    };

    "dp@ubuntu-vm" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self;};
      modules = [(self + "/home/configs/dp@ubuntu-vm.nix")];
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
    };
  };
}
