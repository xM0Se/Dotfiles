{
  lib,
  config,
  ...
}: {
  imports = [
    # ./vscodevim.nix
  ];

  options = {
    vscode.extentions.enable =
      lib.mkEnableOption "vscode.extentions";
  };

  config = lib.mkIf config.vscode.extentions.enable {
    vscode.extentions = {
      # vscodevim.enable =
      # lib.mkDefault true;
    };
  };
}
