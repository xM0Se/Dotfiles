{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    ../modules/nixos/ssh
    ../modules/common/sops.nix
    ../modules/common/home-manager.nix
    ../modules/common/common.nix
  ];

  custom = {
    home-manager.enable =
      lib.mkDefault true;

    ssh.enable =
      lib.mkDefault true;

    sops.enable =
      lib.mkDefault true;
  };
}
