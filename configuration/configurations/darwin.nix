{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
    inputs.home-manager.darwinModules.home-manager

    ../modules/darwin
    ../modules/darwin/dock.nix
    ../modules/darwin/system-data-cleanup.nix
    ../modules/darwin/finder.nix
    ../modules/darwin/hotcorners.nix
    ../modules/common/home-manager.nix
    ../modules/common/sops.nix
    ../modules/common/common.nix
  ];

  custom = {
    home-manager.enable =
      lib.mkDefault true;

    sops.enable =
      lib.mkDefault true;

    system-data-cleanup.enable =
      lib.mkDefault true;
  };
}
