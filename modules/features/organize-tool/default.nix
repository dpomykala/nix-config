_: {
  flake.modules.homeManager.organize-tool =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [ pkgs.organize-tool ];

      # Use a config file encrypted with SOPS
      sops.secrets.organize-config = {
        # Decrypt the whole file, not a single key
        key = "";

        # sops-nix links the decrypted file here
        path = "${config.xdg.configHome}/organize/config.yaml";

        sopsFile = ./config.sops.yaml;
      };
    };
}
