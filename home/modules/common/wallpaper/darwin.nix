{
  lib,
  config,
  wallpaper,
  ...
}: {
  options = {
    wallpaper.darwin.enable =
      lib.mkEnableOption "wallpaper darwin";
  };
  config = lib.mkIf config.wallpaper.darwin.enable {
    home.activation.setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Setting macOS wallpaper from Nix store..."
      /usr/bin/osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"${wallpaper}\""
    '';
  };
}
