{
  description = "xM0Se NIX Flake";

  inputs = {
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    colmena.url = "github:zhaofengli/colmena";

    disko.url = "github:nix-community/disko";

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    determinate.url = "github:DeterminateSystems/determinate";

    vicinae.url = "github:vicinaehq/vicinae";

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nvf,
    flake-parts,
    colmena,
    ...
  }: let
    hosts = import ./hosts;
    mkHost = import ./lib/builders/mkHost.nix {
      inherit inputs self hosts;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs self;} {
      imports = [
        inputs.terranix.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: {
        terranix.terranixConfigurations.default = {
          terraformWrapper.package = pkgs.opentofu;
          extraArgs = {inherit hosts;};
          modules = [
            ./terranix
          ];
        };

        packages.nvim =
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              ./pkgs/custom/nvim
            ];
          }).neovim;
      };

      flake = {lib, ...}: {
        nixConfig = {
          extra-substituters = [
            "https://vicinae.cachix.org"
            "https://nixos-raspberrypi.cachix.org"
          ];
          extra-trusted-public-keys = [
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };

        colmenaHive = import ./lib/builders/mkColmena.nix {
          inherit inputs self hosts colmena nixpkgs lib;
        };

        nixosConfigurations =
          lib.mapAttrs
          mkHost
          (lib.filterAttrs (_: h: h.type == "nixos") hosts);

        darwinConfigurations =
          lib.mapAttrs
          mkHost
          (lib.filterAttrs (_: h: h.type == "darwin") hosts);

        raspberryPiConfigurations =
          lib.mapAttrs
          mkHost
          (lib.filterAttrs (_: h: h.type == "rbpi") hosts);
      };
    };
}
