{lib, ...}: {
  imports = [
    ../modules/nixos/ssh
    ../modules/nixos/sops.nix
    ../modules/nixos/home-manager.nix
    ../modules/common/common.nix
  ];
  custom.ssh.enable =
    lib.mkDefault true;
  custom.sops.enable =
    lib.mkDefault true;
}
