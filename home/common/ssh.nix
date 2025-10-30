/*
This setup allows for managing all SSH keys using 1Password.

Requirements:
  1. The 1Password desktop app must be installed.
  2. The SSH agent must be enabled in the 1Password app.
  3. Identity files must be available (if specified in config)

WARN: Installing 1Password GUI through Home Manager is not reliable.
It requires the setuid permission for the chrome-sandbox executable,
which must be set manually with sudo.

On Darwin, 1Password is installed via nix-darwin (Homebrew).
On NixOS, you can use the dedicated 1Password module.
On generic Linux, install manually using your preferred method.

For more information see: https://developer.1password.com/docs/ssh
*/
{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.strings) escape;

  ssh_agent_socket = escape [" "] (
    if pkgs.stdenv.isLinux
    then "~/.1password/agent.sock"
    # For Darwin hosts
    else "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  );
in {
  home.sessionVariables.SSH_AUTH_SOCK = ssh_agent_socket;

  # Create the 1Password SSH agent config file
  # See: https://developer.1password.com/docs/ssh/agent/config
  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    # Add all SSH keys from the account with this sign-in address
    account = "my.1password.com"
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Rules for specific hosts
    # The order of blocks is not guaranteed unless DAG functions are used
    matchBlocks = {
      # Global config for all hosts
      "*" = {
        identityAgent = ssh_agent_socket;
        # Only use the identities specified explicitly in the config file
        # identitiesOnly = true;
      };

      "github.com* gh*" = {
        hostname = "github.com";
        user = "git";
      };
    };
  };
}
