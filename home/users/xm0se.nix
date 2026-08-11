{config, ...}: {
  imports = [
    ./server-ssh-keys.nix
  ];

  home = {
    username = "xm0se";
    homeDirectory = "/Users/xm0se";
  };

  sops.secrets = {
    "ssh-private-keys/github" = {
      path = "${config.home.homeDirectory}/.ssh/github";
      mode = "0600";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github";
      };
    };
  };
}
