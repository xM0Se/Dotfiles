{
  pkgs,
  inputs,
  config,
  self,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ./disko.nix
    (self + "/configuration/configurations/server.nix")
  ];

  options.sops.enable = false;

  sops = {
    defaultSopsFile = "${self}/secrets/ssh-honeypot.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
  };

  home-manager.users = {
    moritz = {
      imports = [
        (self + "/home/configurations/server.nix")
        (self + "/home/users/moritz.nix")
      ];
    };
    root = {
      imports = [
        (self + "/home/configurations/server.nix")
        (self + "/home/users/root.nix")
      ];
    };
  };

  networking = {
    hostName = "nixos";
    firewall.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  sops.secrets = {
    "userPasswords/moritz".neededForUsers = true;
    "userPasswords/root".neededForUsers = true;
  };

  users = {
    mutableUsers = false;
    users = {
      moritz = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        home = "/moritz";
        hashedPasswordFile = config.sops.secrets."userPasswords/moritz".path;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBl1kqPOoIsYob5yTncLgTFqB5MgLl+2lnAe4hEoYpL nix-server"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALKJQ+LNa7PhF38vRiBFXU6YHEiHyb9h3EnBfneUTel nix-server-deploy"];
      };
      root = {
        home = "/root";
        hashedPasswordFile = config.sops.secrets."userPasswords/root".path;
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = ["deploy"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.sops
    pkgs.git
    pkgs.wget
  ];

  services = {
    xserver.xkb.layout = "us";
    openssh = {
      enable = true;
      openFirewall = false;
      ports = [2222];
      settings = {
        UseDns = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      twingate-connector = {
        image = "twingate/connector:latest";

        environment = {
          TWINGATE_NETWORK = "xmose";
          TWINGATE_ACCESS_TOKEN = config.sops.secrets."twingate/accessToken";
          TWINGATE_REFRESH_TOKEN = config.sops.secrets."twingate/refreshToken";

          TWINGATE_LOG_ANALYTICS = "v2";
          TWINGATE_LOG_LEVEL = "3";
        };

        autoStart = true;
      };

      cowrie = {
        image = "cowrie/cowrie:latest";

        ports = [
          "22:2222"
        ];

        volumes = [
          "/var/lib/cowrie/etc:/cowrie/cowrie-git/etc"
          "/var/lib/cowrie/log:/cowrie/cowrie-git/var/log"
          "/var/lib/cowrie/downloads:/cowrie/cowrie-git/var/lib/cowrie/downloads"
        ];

        environment = {
          TZ = "Europe/Berlin";
        };

        autoStart = true;
      };
    };
  };

  services = {
    prometheus = {
      enable = true;
    };
    loki = {
      enable = true;
    };
    grafana = {
      enable = true;
    };
  };

  system.stateVersion = "25.05";
}
