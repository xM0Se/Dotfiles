{
  lib,
  config,
  ...
}: {
  options = {
    vicinae.macos-settings.enable =
      lib.mkEnableOption "macos-settings";
  };

  config = lib.mkIf config.sops.enable {
    programs.vicinae.settings.providers.macos-settings.enabled = false;
  };
}
