{
  inputs,
  self,
  nixpkgs,
  hosts,
  lib,
  ...
}:
inputs.colmena.lib.makeHive (
  {
    meta = {
      nixpkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      specialArgs = {
        inherit inputs self hosts;
      };
    };
  }
  // (lib.mapAttrs
    (_name: host: {
      imports = host.modules;

      inherit (host) deployment;
    })
    (lib.filterAttrs
      (_name: host: host.system == "x86_64-linux")
      hosts))
)
