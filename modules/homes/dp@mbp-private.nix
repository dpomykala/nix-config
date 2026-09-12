# Configuration specific to the user `dp` on the host `mbp-private`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-private" = {
    imports = with self.modules.homeManager; [
      # Profiles
      development
      home-darwin

      # Features

      # User
      dp
    ];
  };
}
