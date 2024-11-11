# This setup allows for managing all SSH keys using 1Password.
#
# Requirements:
#   1. The 1Password desktop app must be installed.
#   2. The SSH agent must be enabled in the 1Password app.
#
# See: https://developer.1password.com/docs/ssh

{ config, ... }:

let
  # Use the 1Password SSH agent
  ssh_agent_socket =
    "${config.home.homeDirectory}/Library/Group Containers/"
    + "2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  home = {
    sessionVariables = {
      SSH_AUTH_SOCK = ssh_agent_socket;
    };

    # Create the 1Password SSH agent config file
    # See: https://developer.1password.com/docs/ssh/agent/config
    file."${config.xdg.configHome}/1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };

  programs.ssh = {
    enable = true;

    # Rules for specific hosts
    # The order of blocks is not guaranteed unless DAG functions are used
    #matchBlocks = {
    #
    #  # Common configuration for all GitHub hosts
    #  "github.com* gh*" = {
    #    hostname = "github.com";
    #    user = "git";
    #  };
    #  
    #  # Default GitHub account (e.g. for work)
    #  "github.com gh" = {
    #    identityFile = "~/.ssh/id_ed25519_github_work.pub";
    #  };
    #
    #  # Secondary GitHub account (e.g. personal)
    #  "github.com-personal gh-personal" = {
    #    identityFile = "~/.ssh/id_ed25519_github_personal.pub";
    #  };
    #
    #};

    # Rules for the general "Host *" section
    extraConfig = ''
      IdentityAgent "${ssh_agent_socket}"
      
      # Only use the identities specified explicitly in the config file
      # IdentitiesOnly yes
    '';
  };
}
