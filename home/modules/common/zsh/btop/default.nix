{
  lib,
  config,
  ...
}: {
  options = {
    btopconf.enable =
      lib.mkEnableOption "enables btopconf";
  };

  config = lib.mkIf config.btopconf.enable {
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
