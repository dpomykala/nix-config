/*
This setup allows for managing all SSH keys using 1Password.

Requirements:
  1. The 1Password desktop app must be installed.
  2. The SSH agent must be enabled in the 1Password app.

WARN: Installing 1Password GUI through Home Manager is not reliable.
It requires the setuid permission for the chrome-sandbox executable,
which must be set manually with sudo.

On Darwin, 1Password is installed via nix-darwin (Homebrew).
On NixOS, you can use the dedicated 1Password module.
On generic Linux, install manually using your preferred method.

For more information see: https://developer.1password.com/docs/ssh
*/
{pkgs, ...}: let
  ssh_agent_socket =
    if pkgs.stdenv.isLinux
    then "~/.1password/agent.sock"
    # For Darwin hosts
    else "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in {
  home.sessionVariables.SSH_AUTH_SOCK = ssh_agent_socket;

  # Create the 1Password SSH agent config file
  # See: https://developer.1password.com/docs/ssh/agent/config
  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "Private"
  '';

  programs.ssh = {
    enable = true;

    # Rules for specific hosts
    # The order of blocks is not guaranteed unless DAG functions are used
    # matchBlocks = {
    #   # Common configuration for all GitHub hosts
    #   "github.com* gh*" = {
    #     hostname = "github.com";
    #     user = "git";
    #   };
    #
    #   # Default GitHub account (e.g. for work)
    #   "github.com gh" = {
    #     identityFile = "~/.ssh/id_ed25519_github_work.pub";
    #   };
    #
    #   # Secondary GitHub account (e.g. personal)
    #   "github.com-personal gh-personal" = {
    #     identityFile = "~/.ssh/id_ed25519_github_personal.pub";
    #   };
    # };

    # Rules for the general "Host *" section
    extraConfig = ''
      IdentityAgent "${ssh_agent_socket}"

      # Only use the identities specified explicitly in the config file
      # IdentitiesOnly yes
    '';
  };
}
