{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    just.enable =
      lib.mkEnableOption "just";
  };
  config = lib.mkIf config.just.enable {
    home.packages = [
      pkgs.just
    ];
    programs.zsh.shellAliases = {
      j = "just";
    };
  };
}
