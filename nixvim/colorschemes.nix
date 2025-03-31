{
  config,
  lib,
  ...
}: {
  colorschemes.catppuccin = {
    enable = true;

    settings = {
      flavour = "macchiato";

      integrations = lib.mkMerge [
        # TODO: Remove when the default value is changed to true
        (lib.mkIf config.plugins.blink-cmp.enable {blink_cmp = true;})

        (lib.mkIf config.plugins.grug-far.enable {grug_far = true;})

        # TODO: Remove when the default value is changed as below
        (lib.mkIf config.plugins.mini.enable {
          mini = {
            enabled = true;
            indentscope_color = "overlay2";
          };
        })

        # TODO: Remove when the default value is changed to true
        (lib.mkIf config.plugins.noice.enable {noice = true;})

        # TODO: Remove when the default value is changed to true
        (lib.mkIf config.plugins.snacks.enable {
          snacks = {
            enabled = true;
          };
        })
      ];
    };
  };
}
