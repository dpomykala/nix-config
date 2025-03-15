/*
Configuration specific to all Linux hosts.
*/
{config, ...}: {
  imports = [
    ../common
  ];

  home.homeDirectory = "/home/${config.home.username}";
}
