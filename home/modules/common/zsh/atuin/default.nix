{
  lib,
  config,
  ...
}: {
  options = {
    atuin.enable =
      lib.mkEnableOption "atuin";
  };

  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      settings = {
        enter_accept = false;
      };
      flags = ["--disable-ctrl-r"];
      forceOverwriteSettings = true;
      enableZshIntegration = true;
    };
  };
}
