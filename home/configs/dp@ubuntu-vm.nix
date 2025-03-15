/*
Configuration specific to the user `dp` on the host `ubuntu-vm`.
*/
_: {
  imports = [
    ../users/dp.nix
    ../hosts/ubuntu-vm
  ];
}
