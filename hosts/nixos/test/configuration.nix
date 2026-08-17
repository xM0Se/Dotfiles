{
  pkgs,
  inputs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (self + "/configuration/configurations/nixos.nix")
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
  };

  custom.sops.enable = false;
  sops = {
    defaultSopsFile = "${self}/secrets/nixos-test.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
  };

  home-manager.users = {
    xM0Se = {
      imports = [
        (self + "/home/configurations/nixos.nix")
        (self + "/home/users/xM0Se.nix")
      ];
    };
    root = {
      imports = [
        (self + "/home/configurations/nixos.nix")
        (self + "/home/users/root.nix")
      ];
    };
  };

  networking = {
    hostName = "nixos-test";
    firewall = {
      enable = true;
    };
  };

  time.timeZone = "Europe/Berlin";

  sops = {
    secrets = {
      "userPasswords/xM0Se".neededForUsers = true;
      "userPasswords/root".neededForUsers = true;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      xM0Se = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        home = "/xM0Se";
        hashedPasswordFile = config.sops.secrets."userPasswords/xM0Se".path;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJK1atrcGj/65s4ADf2/m3vInIkCZejT8fzIbsnpu/HJ nixos-test-xM0Se"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINE2RM+KeahSKK+zvkhvElVVYP9qUL8Gx5RFYTI8zQC5 nixos-test-deploy"];
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
    xnixos.xkb.layout = "us";
  };

  system.stateVersion = "25.05";
}
