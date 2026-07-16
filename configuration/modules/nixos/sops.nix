{
  inputs,
  self,
  config,
  lib,
  ...
}: {
  options = {
    options.sops.enable =
      lib.mkEnableOption "sops";
  };
  config = lib.mkIf config.options.sops.enable {
    imports = [inputs.sops-nix.nixosModules.sops];

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
