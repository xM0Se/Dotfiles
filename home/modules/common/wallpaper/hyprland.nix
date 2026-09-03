{
  pkgs,
  wallpaper,
  config,
  lib,
  ...
}: {
  options = {
    wallpaper.hyprland.enable =
      lib.mkEnableOption "wallpaper hyprland";
  };

  config = lib.mkIf config.wallpaper.hyprland.enable {
    services.hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${wallpaper}";
          }
        ];
      };
    };
  };
}
