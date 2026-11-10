{ self, ... }: {
  flake.modules.generic.my-lib = {
    _module.args.myLib = self.lib.my;
  };
}
