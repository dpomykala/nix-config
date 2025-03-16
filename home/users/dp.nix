/*
Configuration specific to the user `dp` (on all hosts).
*/
_: {
  home.username = "dp";

  programs.git = {
    # To conditionally specify different Git identity (e.g. for work):
    # includes = {
    #   condition = "hasconfig:remote.*.url:git@git.example-company.com/**";
    #   contents.user.email = "me@example-company.com";
    # }

    userName = "Damian Pomykała";

    # Personal account
    userEmail = "168227269+dpomykala@users.noreply.github.com";
  };
}
