/*
Configuration specific to the user `dp` on the host `mbp-private`.
*/
_: {
  imports = [
    ../../hosts/mbp-private
    ../../users/dp.nix
    # ./organize-tool
  ];

  programs.git.settings.user.email = "168227269+dpomykala@users.noreply.github.com";
}
