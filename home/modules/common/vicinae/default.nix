{inputs, ...}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.mac-app-util.homeManagerModules.default
    ./bitwarden.nix
    ./hidden_mac_apps.nix
    ./hidden_mac_settings.nix
  ];

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
}
