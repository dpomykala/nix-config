{ self, ... }: {
  flake.modules.generic.my-lib = {
    # Pass the custom lib as the `myLib` module system argument
    _module.args.myLib = self.lib.my;
  };
}
