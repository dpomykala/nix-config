# Configuration specific to the user `dp` on the host `mbp-positive`.
{ self, ... }: {
  flake.modules.homeManager."dp@mbp-positive" =
    {
      config,
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
        difftastic
        ffmpeg
        figlet
        glab
        gum
        vhs
      ];

      sops.secrets.userEmail.sopsFile = self + "/secrets/homes/dp@mbp-positive.yaml";

      # Private GitHub identity for repos with a remote under `dpomykala` (SSH
      # or HTTPS). Other repos keep the default (work) identity.
      programs.git.includes =
        map
          (url: {
            condition = "hasconfig:remote.*.url:${url}/**";
            contents = {
              user.email = config.meta.user.email;
              core.sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_github_private.pub";
            };
          })
          [
            "git@github.com:dpomykala"
            "https://github.com/dpomykala"
          ];

      # Uses the private key from 1Password (`1password-ssh-agent` feature)
      home.file.".ssh/id_ed25519_github_private.pub".text =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXOJeYU8ruwfVBWRimv+94LWClpzd4RMupZ6+Tjliva\n";
    };
}
