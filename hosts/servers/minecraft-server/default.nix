{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = true;
    serverType = "cx23";
    labels = {
      role = "minecraft-server";
      managed = "nix";
    };
    protect = true;
  };

  deployment = {
    targetHost = "nix-server-deploy";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };
  modules = [
    ./configuration.nix
  ];
}
