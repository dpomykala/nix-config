/*
Configuration specific to the user `dp` on the host `ubuntu-vm`.
*/
_: {
  imports = [
    ../hosts/ubuntu-vm
    ../users/dp.nix
  ];
}
