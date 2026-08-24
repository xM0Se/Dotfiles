# !! WARNING !!
# MASSIVE SECURITY ISSUE
# TESTING ONLY read line [63]
{
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    (self + "/configuration/configurations/nixos.nix")
  ];

  programs.hyprland.enable = true;
  programs.zsh.enable = true;

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
    moritz = {
      imports = [
        (self + "/home/configurations/nixos.nix")
        (self + "/home/users/moritz.nix")
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
      "userPasswords/moritz".neededForUsers = true;
      "userPasswords/root".neededForUsers = true;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      moritz = {
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = ["wheel" "input"]; # !!MASSIVE SECURITY ISSUE!! Adding input to user group causes everything running under that user has access to all keystrokes !!
        home = "/moritz";
        hashedPasswordFile = config.sops.secrets."userPasswords/moritz".path;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJK1atrcGj/65s4ADf2/m3vInIkCZejT8fzIbsnpu/HJ nixos-test-xM0Se"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINE2RM+KeahSKK+zvkhvElVVYP9qUL8Gx5RFYTI8zQC5 nixos-test-deploy"];
      };
      root = {
        shell = pkgs.zsh;
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

  services.xserver.xkb.layout = "us";

  system.stateVersion = "25.05";
}
