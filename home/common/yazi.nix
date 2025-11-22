{self, ...}: {
  programs.yazi = let
    flavor = "catppuccin-macchiato";
  in {
    enable = true;

    flavors."${flavor}" = "${self.inputs.yazi-flavors}/${flavor}.yazi";

    shellWrapperName = "y";

    theme.flavor = {
      dark = flavor;
      light = flavor;
    };
  };
}
