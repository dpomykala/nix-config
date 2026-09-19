# Factory for creating dendritic user modules.
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
