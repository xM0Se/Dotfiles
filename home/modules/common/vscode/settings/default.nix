{
  lib,
  config,
  ...
}: {
  imports = [
    ./theme.nix
    ./sidebar.nix
  ];

  options = {
    vscode.settings.enable =
      lib.mkEnableOption "enables custom settings";
  };

  config = lib.mkIf config.vscode.settings.enable {
    vscode = {
      settings = {
        theme.enable =
          lib.mkDefault true;
        sidebar.enable =
          lib.mkDefault true;
      };
    };
  };
}
