/*
Configuration specific to the user `dp` on the host `mbp-16`.
*/
{config, ...}: let
  gitconfigWorkLeanlabSecretFile = "gitconfig-work-leanlab";
in {
  imports = [
    ../../hosts/mbp-16
    ../../users/dp.nix
    ./organize-tool
  ];

  programs.git = let
    includeWithLeanlabSecrets = includeAttrs: [
      includeAttrs
      {
        inherit (includeAttrs) condition;
        inherit (config.sops.templates."${gitconfigWorkLeanlabSecretFile}") path;
      }
    ];
  in {
    # Conditionally specify Git identity / SSH key based on the remote URL
    includes =
      [
        # Default GitHub account
        # NOTE: This should be the first item in the list, so it can be overwritten
        {
          condition = "hasconfig:remote.*.url:*github.com*/**";
          contents = {
            core.sshCommand = "ssh -i ~/.ssh/id_ed25519_github_personal.pub";
            user.email = "168227269+dpomykala@users.noreply.github.com";
          };
        }

        # Work Git server (Bitbucket)
        {
          inherit (config.sops.templates.gitconfig-work-leanlab) path;

          condition = "hasconfig:remote.*.url:*//*git.leanlab.pl*/**";
        }
      ]
      # Work GitHub account
      ++ includeWithLeanlabSecrets {
        condition = "hasconfig:remote.*.url:*github.com*:leanlabpl/**";
        contents.core.sshCommand = "ssh -i ~/.ssh/id_ed25519_github_work_leanlab.pub";
      };
  };

  programs.ssh = {
    # Rules for specific hosts
    # The order of blocks is not guaranteed unless DAG functions are used
    matchBlocks = {
      "github.com" = {
        identitiesOnly = true;
      };

      # Work Git server (Bitbucket)
      "git.leanlab.pl" = {
        extraOptions = {
          # Allow RSA keys
          HostkeyAlgorithms = "+ssh-rsa";
          PubkeyAcceptedAlgorithms = "+ssh-rsa";
        };
      };
    };
  };

  sops = {
    secrets.workEmailLeanlab.sopsFile = ./secrets.yaml;

    templates."${gitconfigWorkLeanlabSecretFile}".content = ''
      [user]
        email = "${config.sops.placeholder.workEmailLeanlab}"
    '';
  };
}
