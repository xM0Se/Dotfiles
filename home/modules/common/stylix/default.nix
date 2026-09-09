{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    # image = "";
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 32;
    };
    fonts = {
      #   serif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Serif";
      #   };
      #
      #   sansSerif = {
      #     package = pkgs.dejavu_fonts;
      #     name = "DejaVu Sans";
      #   };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.openmoji-color;
        name = "OpenMoji Color";
      };
    };
  };
}
