{
  lib,
  config,
  ...
}: {
  options = {
    vscode.settings.sidebar.enable =
      lib.mkEnableOption "sets the sidebar to the right side";
  };

  config = lib.mkIf config.vscode.settings.sidebar.enable {
    programs.vscode.profiles.default.userSettings = {
      "workbench.sideBar.location" = "right";
    };
  };
}
