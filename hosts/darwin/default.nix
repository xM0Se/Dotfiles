{
  provider = "local";
  type = "darwin";
  system = "aarch64-darwin";

  modules = [
    ./configuration.nix
  ];
}
