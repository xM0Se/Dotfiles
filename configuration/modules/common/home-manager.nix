{
  self,
  inputs,
  config,
  lib,
  ...
}: {
  options = {
    custom.home-manager.enable =
      lib.mkEnableOption "home-manager";
  };

  config = lib.mkIf config.custom.home-manager.enable {
    home-manager = {
      extraSpecialArgs = {inherit inputs self;};
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };
}
