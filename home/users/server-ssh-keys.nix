{config, ...}: let
  servers = {
    ssh-honeypot = {
      host = "10.0.1.3";
    };
    minecraft-server = {
      host = "0.0.0.0"; # Placeholder
    };
    server-01 = {
      host = "0.0.0.0"; # Placeholder
    };
    server-02 = {
      host = "0.0.0.0"; # Placeholder
    };
  };

  users = ["moritz" "deploy"];

  sshKey = server: user: "${config.home.homeDirectory}/.ssh/${server}-${user}";

  serverSecrets = builtins.listToAttrs (
    builtins.concatLists (
      map (
        server:
          map (user: {
            name = "servers/${server}/ssh-private-keys/${user}";
            value = {
              path = sshKey server user;
              mode = "0600";
            };
          })
          users
      ) (builtins.attrNames servers)
    )
  );

  serverHosts = builtins.listToAttrs (
    builtins.concatLists (
      map (
        server:
          map (user: {
            name = "${server}-${user}";
            value = {
              HostName = servers.${server}.host;
              User = user;
              IdentityFile = "~/.ssh/${server}-${user}";
            };
          })
          users
      ) (builtins.attrNames servers)
    )
  );
in {
  sops.secrets =
    serverSecrets;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings =
      serverHosts;
  };
}
