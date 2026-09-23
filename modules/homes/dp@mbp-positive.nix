# Configuration specific to the user `dp` on the host `mbp-positive`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-positive" = { pkgs, ... }: {
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

    home.packages = with pkgs; [
      claude-code
      glab
    ];

    sops.secrets.userEmail.sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";
  };
}
