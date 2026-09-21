# Configuration specific to the user `dp` on the host `vm-ubuntu`.
{ self, ... }: {
  flake.modules.homeManager."dp@vm-ubuntu" = {
    imports = with self.modules.homeManager; [
      # Profiles
      development
      home-linux-generic

      # Features

      # User
      dp
    ];
  };
}
