{
  lib,
  config,
  ...
}: {
  options = {
    oh-my-posh.enable =
      lib.mkEnableOption "oh-my-posh";
  };
  config = lib.mkIf config.oh-my-posh.enable {
    programs.oh-my-posh = {
      enable = true;
      configFile = ./base.json;
      enableZshIntegration = true;
    };
  };
}
