/*
Configuration specific to the user `dp` on the host `vm-ubuntu`.
*/
_: {
  imports = [
    ../hosts/vm-ubuntu
    ../users/dp.nix
  ];
}
