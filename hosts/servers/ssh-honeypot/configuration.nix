{
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./twingate.nix
    ./crowdsec.nix
    (self + "/configuration/configurations/server.nix")
    ./cowrie.nix
    ./vector.nix
    ./loki.nix
    ./grafana.nix
  ];

  custom.sops.enable = false;
  custom.ssh.enable = false;

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
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      extraCommands = ''
        iptables -A nixos-fw -s 10.0.1.0/24 -j nixos-fw-accept
      '';
    };
  };

  time.timeZone = "Europe/Berlin";

  sops = {
    secrets = {
      "MaxMind/license_key" = {
        owner = "root";
        group = "root";
      };
      "userPasswords/moritz".neededForUsers = true;
      "userPasswords/root".neededForUsers = true;
    };
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

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

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

    geoipupdate = {
      enable = true;
      settings = {
        AccountID = 1380455;
        LicenseKey = "/run/credentials/geoipupdate.service/maxmind_license_key";
        EditionIDs = [
          "GeoLite2-ASN"
          "GeoLite2-City"
          "GeoLite2-Country"
        ];
      };
    };

    # prometheus = {
    #   enable = true;
    # };
  };

  systemd.services = {
    geoipupdate.serviceConfig.LoadCredential = [
      "maxmind_license_key:${config.sops.secrets."MaxMind/license_key".path}"
    ];
  };

  system.stateVersion = "25.05";
}
