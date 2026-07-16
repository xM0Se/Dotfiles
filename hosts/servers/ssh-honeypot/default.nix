{
  provider = "hetzner";
  type = "nixos";
  system = "x86_64-linux";

  hetzner = {
    enable = true;
    serverType = "cx23";
    labels = {
      role = "ssh-honeypot";
    };
    protect = false;
  };

  deployment = {
    targetHost = "";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}
