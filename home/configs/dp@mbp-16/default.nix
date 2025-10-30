/*
Configuration specific to the user `dp` on the host `mbp-16`.
*/
_: {
  imports = [
    ../../hosts/mbp-16
    ../../users/dp.nix
    ./organize-tool
  ];

  programs.ssh = {
    # Rules for specific hosts
    # The order of blocks is not guaranteed unless DAG functions are used
    matchBlocks = {
      # Default GitHub account (personal)
      "github.com gh" = {
        identityFile = "~/.ssh/id_ed25519_github_personal.pub";
      };

      # Secondary GitHub account (work)
      "github.com-ll gh-ll" = {
        identityFile = "~/.ssh/id_ed25519_github_work_ll.pub";
      };
    };
  };
}
