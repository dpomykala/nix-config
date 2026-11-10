# The `dp` user, which all hosts and homes import
{ self, ... }: {
  flake.modules = self.factory.user {
    name = "dp";
    fullName = "Damian Pomykała";
    email = "168227269+dpomykala@users.noreply.github.com";
    isPrimary = true;
  };
}
