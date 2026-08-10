{
  description = "xM0Se NIX Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
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

    colmena = {
      url = "github:zhaofengli/colmena/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    neru.url = "github:y3owk1n/neru";
    neru.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nvf,
    flake-parts,
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
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem = {system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
      in {
        formatter = pkgs.alejandra;

        terranix.terranixConfigurations.terranix = {
          terraformWrapper.package = pkgs.opentofu;
          extraArgs = {inherit hosts;};
          modules = [
            ./terranix
          ];
        };

        packages =
          {
            nvim =
              (nvf.lib.neovimConfiguration {
                inherit pkgs;
                modules = [
                  ./pkgs/custom/nvim
                ];
              }).neovim;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
            mole = pkgs.custom.mole;
          };
      };

      flake = {lib, ...}: {
        overlays.default = final: _prev: {
          custom = {
            mole = final.callPackage ./pkgs/custom/mole {};
          };
        };

        colmenaHive = import ./lib/builders/mkColmena.nix {
          inherit inputs self hosts nixpkgs lib;
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
