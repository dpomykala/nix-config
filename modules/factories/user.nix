# Factory that creates the Darwin and Home Manager modules of a user
_: {
  flake.factory.user =
    {
      name,
      fullName,
      email ? null,
      isPrimary ? false,
    }:
    let
      user = { inherit name fullName email; };
    in
    {
      darwin.${name} = { lib, ... }: {
        meta.user = user;

        config = lib.mkIf isPrimary {
          system.primaryUser = name;
        };
      };

      homeManager.${name} = {
        meta.user = user;

        home.username = name;
      };
    };
}
