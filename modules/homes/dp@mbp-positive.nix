# Configuration specific to the user `dp` on the host `mbp-positive`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-positive" = {
    imports = with self.modules.homeManager; [
      # Profiles
      development
      home-darwin

      # Features
      karabiner

      # User
      dp
    ];

    sops.secrets.userEmail.sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";
  };
}
