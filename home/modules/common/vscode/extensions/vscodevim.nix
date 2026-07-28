{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    vscode.extensions.vscodevim.enable =
      lib.mkEnableOption "installs vscodevim for vscode";
  };

  config = lib.mkIf config.vscode.extensions.vscodevim.enable {
    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
    ];
  };
}
