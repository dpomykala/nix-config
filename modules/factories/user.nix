# Factory for creating dendritic user modules.
{ self, ... }: {
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
        imports = [ self.modules.generic.meta ];

        meta.user = user;

        config = lib.mkIf isPrimary {
          system.primaryUser = name;
        };
      };

      homeManager.${name} = {
        imports = [ self.modules.generic.meta ];

        meta.user = user;

        home.username = name;
      };
    };
}
