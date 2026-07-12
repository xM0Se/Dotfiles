{
  provider = "local";
  type = "rbpi";
  system = "aarch64-linux";

  modules = [
    ./configuration.nix
  ];
}
