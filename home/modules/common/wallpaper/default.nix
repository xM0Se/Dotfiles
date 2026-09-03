{
  pkgs,
  config,
  lib,
  ...
}: let
  wallpaper = pkgs.fetchurl {
    name = "wallpaper.jpg";
    url = "https://unsplash.com/photos/MNsXlmQ3r1g/download";
    sha256 = "sha256-pKuX1iriGXUgstcHmRJpb50/4HK/KflFleNQ/zw1xIA=";
  };
in {
  imports = [
    (import ./hyprland.nix {inherit pkgs config lib wallpaper;})
    (import ./darwin.nix {inherit pkgs config lib wallpaper;})
  ];

  options = {
    wallpaper.enable =
      lib.mkEnableOption "wallpaper";
  };
  config = lib.mkIf config.wallpaper.enable {
    wallpaper = {
      hyprland.enable = lib.mkIf config.wayland.windowManager.hyprland.enable (
        lib.mkDefault true
      );
      darwin.enable =
        if pkgs.stdenv.hostPlatform.isDarwin
        then lib.mkDefault true
        else lib.mkDefault false;
    };
  };
}
