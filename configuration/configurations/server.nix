{lib, ...}: {
  imports = [
    ../modules/nixos/ssh/default.nix
    ../modules/nixos/sops.nix
    ../modules/nixos/home-manager.nix
    ../modules/common/common.nix
  ];
  options.sops.enable =
    lib.mkDefault true;
}
