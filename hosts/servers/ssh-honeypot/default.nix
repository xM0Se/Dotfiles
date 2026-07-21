{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = true;
    serverType = "cx23";
    network = {
      name = "unsecure";
      ip = "10.0.1.3";
    };
    labels = {
      role = "ssh-honeypot";
    };
    protect = false;
  };

  deployment = {
    targetHost = "ssh-honeypot";
    targetPort = 2222;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
