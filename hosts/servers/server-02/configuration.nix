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
    defaultSopsFile = "${self}/secrets/server-02.yaml";
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
    hostName = "server-02";
    firewall.enable = true;
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
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHU4B3Dh4RTclUfWBnay2DXlETqOL8xpvAYwVmc9oJtV server-02-moritz"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCfKYTWU7hx9TQaV8tECH9WaSJoJ8qE696zggYHnr6P server-02-deploy"];
      };
      root = {
        home = "/root";
        hashedPasswordFile = config.sops.secrets."userPasswords/root".path;
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
