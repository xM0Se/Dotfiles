{
  lib,
  config,
  ...
}: {
  imports = [
    ./settings
    ./extensions
  ];

  options = {
    vscode.enable =
      lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode.enable = true;
    vscode = {
      settings.enable =
        lib.mkDefault true;

      extentions.enable =
        lib.mkDefault true;
    };
  };
}
