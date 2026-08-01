{inputs, ...}: {
  imports = [
    inputs.determinate.darwinModules.default
    inputs.mac-app-util.darwinModules.default
  ];

  determinateNix.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
