{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
  ];

  options = {
    radicle.enable =
      lib.mkEnableOption "radicle";
  };

  config = lib.mkIf config.radicle.enable {
    home.packages = [
      pkgs.radicle-node # Includes `rad`, `radicle-node`, and related tools
      pkgs.radicle-httpd # HTTP API for web interfaces
      pkgs.radicle-tui # Terminal UI
      pkgs.radicle-desktop # Desktop app
      (pkgs.radicle-ci-broker.overrideAttrs (_: {
        # Radicle CI/CD
        doCheck = false; # Radicle CI/CD checks are broken right now
      }))
    ];
  };
}
