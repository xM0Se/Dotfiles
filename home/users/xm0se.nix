{config, ...}: {
  imports = [
    ./server-ssh-keys.nix
  ];

  home = {
    username = "xm0se";
    homeDirectory = "/Users/xm0se";
  };

  sops.secrets = {
    "nixos/nixos-test/xM0Se" = {
      path = "${config.home.homeDirectory}/.ssh/nixos-test-xM0Se";
      mode = "0600";
    };
    "nixos/nixos-test/deploy" = {
      path = "${config.home.homeDirectory}/.ssh/nixos-test-deploy";
      mode = "0600";
    };
    "ssh-private-keys/github" = {
      path = "${config.home.homeDirectory}/.ssh/github";
      mode = "0600";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "nixos-test-xM0Se" = {
        HostName = "192.168.2.5";
        User = "xM0Se";
        IdentityFile = "~/.ssh/nixos-test-xM0Se";
      };
      "nixos-test-deploy" = {
        HostName = "192.168.2.5";
        User = "deploy";
        IdentityFile = "~/.ssh/nixos-test-deploy";
      };
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github";
      };
    };
  };
}
