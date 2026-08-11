{
  provider = "local";
  type = "nixos";
  system = "x86_64-linux";

  deploy = {
    enable = true;
    targetHost = "server-02-deploy";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
