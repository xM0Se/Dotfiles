{
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    (self + "/configuration/configurations/server.nix")
  ];
  custom.sops.enable = false;
  sops = {
    defaultSopsFile = "${self}/secrets/01-server.yaml";
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
    firewall.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  sops.secrets = {
    "userPasswords/01-server/moritz".neededForUsers = true;
    "userPasswords/01-server/root".neededForUsers = true;
  };

  users = {
    mutableUsers = false;
    users = {
      moritz = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        home = "/moritz";
        hashedPasswordFile = config.sops.secrets."userPasswords/01-server/moritz".path;
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
        hashedPasswordFile = config.sops.secrets."userPasswords/01-server/root".path;
      };
    };
  };

  services.xserver.xkb.layout = "us";
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

  system.stateVersion = "25.05";
}
