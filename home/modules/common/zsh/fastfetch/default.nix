{
  lib,
  config,
  ...
}: {
  options = {
    fastfetch.enable =
      lib.mkEnableOption "fastfetch";
  };

  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = {};
    };
  };
}
