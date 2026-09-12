{ self, ... }: {
  flake.modules.homeManager.organize-tool =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.homeManager; [ sops ];

      home.packages = [ pkgs.organize-tool ];

      # Use a config file encrypted with SOPS
      sops.secrets.organize-config = {
        # Do not treat YAML keys as separate secrets
        key = "";

        # Path where the decrypted file will be linked
        path = "${config.xdg.configHome}/organize/config.yaml";

        # Path to the encrypted file
        sopsFile = ./config.sops.yaml;
      };
    };
}
