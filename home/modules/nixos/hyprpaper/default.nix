{pkgs, ...}: let
  wallpaper = pkgs.fetchurl {
    name = "wallpaper.jpg";
    url = "https://unsplash.com/photos/MNsXlmQ3r1g/download";
    sha256 = "sha256-pKuX1iriGXUgstcHmRJpb50/4HK/KflFleNQ/zw1xIA=";
  };
in {
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
}
