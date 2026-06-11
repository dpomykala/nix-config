/*
Configuration specific to the host `mbp-private` (for all users).
*/
{pkgs, ...}: {
  imports = [
    ../../darwin
  ];

  home.packages = with pkgs; [
    ollama
    pi-coding-agent
  ];
}
