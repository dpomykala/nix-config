/*
Configuration specific to all Darwin hosts.
*/
{config, ...}: {
  imports = [
    ../common
    ./karabiner
  ];

  home.homeDirectory = "/Users/${config.home.username}";
}
