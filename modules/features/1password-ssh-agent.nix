/*
  Use 1Password as the SSH agent for all SSH keys.

  Requirements:
    1. The 1Password desktop app is installed.
    2. The SSH agent is enabled in the 1Password app.
    3. Every identity file that the SSH config names exists.

  WARN: Home Manager can't install the 1Password GUI reliably. The GUI needs
  the setuid bit on its chrome-sandbox executable, which only sudo can set.

  On Darwin, the `1password` darwin feature installs 1Password as a Homebrew
  cask. On NixOS, use the 1Password module of NixOS. On x86-64 Debian or
  Ubuntu, run `just deb-1password`. On other Linux distributions, install it
  by hand.

  See https://developer.1password.com/docs/ssh.
*/
_: {
  flake.modules.homeManager."1password-ssh-agent" =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.strings) escape;

      sshAgentSocket = escape [ " " ] (
        if pkgs.stdenv.hostPlatform.isLinux then
          "~/.1password/agent.sock"
        # For Darwin hosts
        else
          "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      );
    in
    {
      home.sessionVariables.SSH_AUTH_SOCK = sshAgentSocket;

      # See https://developer.1password.com/docs/ssh/agent/config
      xdg.configFile."1Password/ssh/agent.toml".text = ''
        [[ssh-keys]]
        # Add all SSH keys from the account with this sign-in address
        account = "my.1password.com"
      '';

      # Home Manager orders host blocks only through its DAG functions
      programs.ssh = {
        enable = lib.mkDefault true;

        settings = {
          "*" = {
            identityAgent = sshAgentSocket;
          };
        };
      };
    };
}
