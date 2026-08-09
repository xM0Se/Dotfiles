{
  provider = "local";
  type = "nixos";
  system = "x86_64-linux";

  deploy = {
    enable = true;
    targetHost = "server-01";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
