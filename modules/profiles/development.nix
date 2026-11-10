# Development environment profile
{ self, ... }: {
  flake.modules.darwin.development = {
    imports = with self.modules.darwin; [
      docker
      shell
    ];
  };

  flake.modules.homeManager.development =
    let
      # The commented-out features aren't in use for now
      langFeatures = with self.modules.homeManager; [
        # elixir
        # go
        javascript
        just
        lua
        nix-lang
        # rust
        shell-lang
        spelling
        web
        # zig
      ];
    in
    {
      imports =
        with self.modules.homeManager;
        [
          # Features
          ai
          bat
          delta
          dev-tools
          docker
          eza
          fzf
          ghostty
          helix
          herdr
          http
          mise
          neovim
          pay-respects
          python
          shell
          ssh
          starship
          superfile
          vim
          zoxide
        ]
        ++ langFeatures;

      # Choose the default editor here, not in an editor feature, so that only
      # one module sets it
      programs.helix.defaultEditor = true;
    };
}
