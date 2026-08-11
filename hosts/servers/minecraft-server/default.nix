{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = false;
    serverType = "cx33";
    network = {
      name = "primary";
      ip = "10.0.1.2";
    };
    labels = {
      role = "minecraft-server";
    };
    protect = true;
  };

  deploy = {
    enable = false;
    targetHost = "minecraft-server-deploy";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
