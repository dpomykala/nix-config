# Configuration specific to the user `dp` on the host `mbp-positive`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-positive" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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

      # Private GitHub identity for the nix-config repo only. Other repos keep
      # the default (work) identity.
      programs.git.includes = [
        {
          condition = "gitdir:**/nix-config/";
          contents =
            lib.optionalAttrs (config.meta.user.email != null) {
              user.email = config.meta.user.email;
            }
            // {
              # NOTE: The public SSH key must be set on dp@mbp-positive
              core.sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_github_private.pub";
            };
        }
      ];
    };
}
