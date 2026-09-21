# Configuration specific to the user `dp` on the host `mbp-private`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-private" = {
    imports =
      with self.modules.homeManager;
      [
        # Profiles
        development
        home-darwin

        # Features
        karabiner

        # User
        dp
      ]
      ++ [
        # Features
        self.modules.homeManager."1password-ssh-agent"
      ];
  };
}
