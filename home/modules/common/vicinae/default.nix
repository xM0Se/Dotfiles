{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.mac-app-util.homeManagerModules.default
    ./bitwarden.nix
    ./hidden_mac_apps.nix
    ./hidden_mac_settings.nix
  ];
  options = {
    vicinae.enable =
      lib.mkEnableOption "vicinae";
  };

  config = lib.mkIf config.vicinae.enable {
    vicinae = {
      bitwarden.enable =
        lib.mkDefault true;
      hidden-mac-apps.enable =
        if pkgs.stdenv.hostPlatform.isDarwin
        then lib.mkDefault true
        else lib.mkDefault false;
      macos-settings.enable =
        if pkgs.stdenv.hostPlatform.isDarwin
        then lib.mkDefault true
        else lib.mkDefault false;
    };

    programs.vicinae = {
      enable = true;
      settings = {
        pop_to_root_on_close = true;
        escape_key_behavior = "close_window";
        font.normal.family = "JetBrains Mono";
        theme.dark.name = "rose-pine-moon";
        launcher_window = {
          compact_mode.enabled = true;
          material = "blur";
        };
      };
    };
  };
}
