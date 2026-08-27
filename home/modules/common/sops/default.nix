{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    sops.enable =
      lib.mkEnableOption "sops";
  };

  config = lib.mkIf config.sops.enable {
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "${config.home.homeDirectory}/.config/sops/age/keys.txt"
        else "/var/lib/sops-nix/key.txt";
    };
  };
}
