{config, ...}: {
  sops = {
    secrets = {
      "virus-total/api-key" = {
        owner = "cowrie";
        group = "cowrie";
        mode = "0400";
      };
      "grey-noise/api-key" = {
        owner = "cowrie";
        group = "cowrie";
        mode = "0400";
      };
      "abuse-IPDB/api-key" = {
        owner = "cowrie";
        group = "cowrie";
        mode = "0400";
      };
    };
  };

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

  system.activationScripts.cowrie = {
    deps = ["setupSecrets"];
    text = ''
      cat > /var/lib/cowrie/etc/cowrie.cfg <<EOF
      [honeypot]
      hostname = minecraft-server

      [output_virustotal]
      enabled = true
      api_key = $(cat ${config.sops.secrets."virus-total/api-key".path})
      upload = true
      scan_file = true
      scan_url = true
      comment = true
      collection = cowrie
      debug = false

      [output_greynoise]
      enabled = true
      api_key = $(cat ${config.sops.secrets."grey-noise/api-key".path})

      [output_abuseipdb]
      enabled = true
      api_key = $(cat ${config.sops.secrets."abuse-IPDB/api-key".path})
      dump_path = var/lib/cowrie/abuseipdb.state
      EOF

      chown cowrie:cowrie /var/lib/cowrie/etc/cowrie.cfg
      chmod 600 /var/lib/cowrie/etc/cowrie.cfg
    '';
  };

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
