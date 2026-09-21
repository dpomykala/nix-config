_: {
  flake.modules.generic.meta = { lib, ... }: {
    options.meta = {
      user = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Username of the configured user.";
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = null;
          description = "User's e-mail address.";
        };

        fullName = lib.mkOption {
          type = lib.types.str;
          description = "User's full name.";
        };
      };
    };
  };
}
