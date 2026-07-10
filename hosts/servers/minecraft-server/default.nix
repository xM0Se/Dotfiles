{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = true;
    serverType = "cx23";
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
