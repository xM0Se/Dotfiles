{
  lib,
  config,
  ...
}: {
  options = {
    vscode.settings.theme.enable =
      lib.mkEnableOption "sets the default thme to dracula";
  };

  config = lib.mkIf config.vscode.settings.theme.enable {
    programs.vscode.profiles.default.userSettings = {
      "workbench.colorTheme" = "Dracula Theme";
    };
  };
}
