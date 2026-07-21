{
  inputs,
  self,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    custom.sops.enable =
      lib.mkEnableOption "sops";
  };

  config = lib.mkIf config.custom.sops.enable {
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
        sshKeyPaths = [];
      };
    };
  };
}
