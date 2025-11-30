/*
Configuration specific to the user `dp` on the host `mbp-14`.
*/
{config, ...}: let
  gitconfigWorkPositiveSecretFile = "gitconfig-work-positive";
in {
  imports = [
    ../../hosts/mbp-14
    ../../users/dp.nix
  ];

  programs.git.includes = [
    {
      inherit (config.sops.templates."${gitconfigWorkPositiveSecretFile}") path;
    }
  ];

  sops = {
    secrets.workEmailPositive.sopsFile = ./secrets.yaml;

    templates."${gitconfigWorkPositiveSecretFile}".content = ''
      [user]
        email = "${config.sops.placeholder.workEmailPositive}"
    '';
  };
}
