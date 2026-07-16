{
  lib,
  config,
  ...
}: {
  options = {
    btop.enable =
      lib.mkEnableOption "btop";
  };

  config = lib.mkIf config.btop.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "rose-pine-moon";
        theme_background = true;
        truecolor = true;
        vim_keys = true;
      };
    };
    xdg.configFile."btop/themes/rose-pine-moon.theme".source = ./rose-pine-moon.theme;
  };
}
