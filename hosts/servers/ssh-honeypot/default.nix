{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = true;
    serverType = "cx23";
    serverLocation = "nbg1";
    network = {
      name = "unsecure";
      ip = "10.0.1.3";
    };
    labels = {
      role = "ssh-honeypot";
    };
    protect = false;
  };

  deploy = {
    enable = true;
    targetHost = "ssh-honeypot";
    targetPort = 2222;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
