_: {
  imports = [
    ../modules/darwin/dock.nix
    ../modules/darwin/system-data-cleanup.nix
    ../modules/darwin/finder.nix
    ../modules/darwin/hotcorners.nix
    ../modules/darwin/sops.nix
    ../modules/darwin/home-manager.nix
    ../modules/common/common.nix
  ];
  system-data-cleanup.enable = true;
}
