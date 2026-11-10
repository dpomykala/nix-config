{ self, ... }: {
  flake.lib.my = import (self + "/lib");
}
