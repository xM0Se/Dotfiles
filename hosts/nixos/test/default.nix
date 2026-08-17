{
  provider = "local";
  type = "nixos";
  system = "x86_64-linux";

  deploy = {
    enable = true;
    targetHost = "nixos-test-deploy";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
