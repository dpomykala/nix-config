/*
Secrets management using SOPS and age encryption.

Requirements:
  1. The age public key (or keys) used for encryption must be specified in
     the `.sops.yaml` file located in the root of this repository.
  2. The corresponding age private key (or keys) must be present in the file
     specified in the `ageKeys` variable.

To encrypt an existing file in this repository:
  sops --encrypt --in-place <FILE>

To create or edit an encrypted file in this repository:
  sops <FILE>

SOPS integration for NixOS/nix-darwin/HM: https://github.com/Mic92/sops-nix
SOPS: https://github.com/getsops/sops
age encryption: https://github.com/FiloSottile/age
*/
{
  config,
  pkgs,
  self,
  ...
}: let
  ageKeys = "${config.xdg.configHome}/sops/age/keys.txt";
in {
  imports = [
    self.inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    packages = [pkgs.sops];
    sessionVariables.SOPS_AGE_KEY_FILE = ageKeys;
  };

  sops.age.keyFile = ageKeys;
}
