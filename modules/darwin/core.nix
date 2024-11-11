{ ... }: {
  nix.settings = {
    # Use new-style commands and flakes 
    experimental-features = "nix-command flakes";
    
    # Conform to the XDG Base Directory Specification
    use-xdg-base-directories = true;
  };

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;
}
