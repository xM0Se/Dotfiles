_: {
  users = {
    groups.cowrie.gid = 991;
    users.cowrie = {
      isSystemUser = true;
      uid = 991;
      group = "cowrie";
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/cowrie 0755 991 991 -"
    "d /var/lib/cowrie/etc 0755 991 991 -"
    "d /var/lib/cowrie/log 0755 991 991 -"
    "d /var/lib/cowrie/log/cowrie 0755 991 991 -"
    "d /var/lib/cowrie/lib 0755 991 991 -"
    "d /var/lib/cowrie/lib/tty 0755 991 991 -"
    "d /var/lib/cowrie/lib/keys 0755 991 991 -"
    "d /var/lib/cowrie/lib/downloads 0755 991 991 -"
  ];

  virtualisation.oci-containers.containers.cowrie = {
    image = "cowrie/cowrie:latest";

    ports = [
      "22:2222"
    ];

    extraOptions = [
      "--user=991:991"
    ];

    volumes = [
      "/var/lib/cowrie/etc:/cowrie/cowrie-git/etc"
      "/var/lib/cowrie/log:/cowrie/cowrie-git/var/log"
      "/var/lib/cowrie/lib:/cowrie/cowrie-git/var/lib/cowrie"
    ];

    environment = {
      TZ = "Europe/Berlin";
    };

    autoStart = true;
  };
}
