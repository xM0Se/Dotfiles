{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.neru.overlays.default
  ];

  imports = [
    inputs.neru.homeManagerModules.default
  ];

  services.neru = {
    enable = true;
    config = ''
      [hotkeys]
      "Primary+Shift+Space" = "hints left_click"
      "Primary+Shift+G" = "grid left_click"

      [general]
      excluded_apps = ["com.apple.Terminal"]
    '';
  };

  # Optional: Use specific package version
  # services.neru.package = pkgs.neru; # This will use the latest version
  # services.neru.package = pkgs.neru-source; # This will build from source
}
