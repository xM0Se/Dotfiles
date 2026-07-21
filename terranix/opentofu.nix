{
  lib,
  pkgs,
  hosts,
  ...
}: let
  hetznerHosts =
    lib.filterAttrs
    (
      _: host:
        host.provider == "hetzner"
    )
    hosts;
  defaultLabels = {
    managed_by = "terraform";
    project = "nix-cluster";
  };
in {
  variable."state_passphrase" = {
    type = "string";
    sensitive = true;
  };

  terraform = {
    encryption = {
      key_provider."pbkdf2"."my_passphrase" = {
        passphrase = "\${var.state_passphrase}";
      };

      method."aes_gcm"."default" = {
        keys = "key_provider.pbkdf2.my_passphrase";
      };

      state = {
        method = "method.aes_gcm.default";
        enforced = true;
      };
    };
    required_providers = {
      sops = {
        source = "carlpett/sops";
      };

      hcloud = {
        source = "hetznercloud/hcloud";
        version = "~> 1.45";
      };

      cloudflare = {
        source = "cloudflare/cloudflare";
        version = "~> 5";
      };
    };
  };

  data.sops_file.opentofu = {
    source_file = "../../secrets/secrets.yaml";
  };

  provider = {
    hcloud = {
      token = "\${data.sops_file.opentofu.data[\"hetzner.api\"]}";
    };

    cloudflare = {
      api_token = "\${data.sops_file.opentofu.data[\"cloudflare.api\"]}";
    };
  };

  resource = {
    hcloud_ssh_key.nixos_anywhere_ssh_pub = {
      name = "nixos_anywhere_ssh_pub";
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBElFsyViicwKf+WifPUdLrHR4hqsQ5gfnXtgPb/UXzW hetzner-nix-anywhere";
    };

    hcloud_network = builtins.listToAttrs (
      map
      (host: {
        name = host.hetzner.network.name;
        value = {
          name = host.hetzner.network.name;
          ip_range = "10.0.1.0/24";
        };
      })
      (builtins.attrValues hetznerHosts)
    );

    hcloud_network_subnet = builtins.listToAttrs (
      map
      (host: {
        name = "${host.hetzner.network.name}_subnet";
        value = {
          type = "cloud";
          network_id = "\${hcloud_network.${host.hetzner.network.name}.id}";
          network_zone = "eu-central";
          ip_range = "10.0.1.0/24";
        };
      })
      (builtins.attrValues hetznerHosts)
    );

    hcloud_server =
      lib.mapAttrs
      (hostname: host: {
        name = hostname;
        server_type = host.hetzner.serverType;
        location = "nbg1";
        labels = defaultLabels // host.hetzner.labels;

        network = {
          subnet_id = "\${hcloud_network_subnet.${host.hetzner.network.name}_subnet.id}";
          ip = "${host.hetzner.network.ip}";
        };

        delete_protection = host.hetzner.protect;
        rebuild_protection = host.hetzner.protect;

        backups = false;
        shutdown_before_deletion = true;
        image = "ubuntu-24.04";
        ssh_keys = [(lib.tf.ref "hcloud_ssh_key.nixos_anywhere_ssh_pub.id")];
      })
      hetznerHosts;
  };

  module =
    lib.mapAttrs'
    (hostname: _host: {
      name = "install_${hostname}";
      value = {
        source = "github.com/nix-community/nixos-anywhere//terraform/install";

        target_host = "\${hcloud_server.${hostname}.ipv4_address}";
        instance_id = "\${hcloud_server.${hostname}.id}";

        ssh_private_key = "\${data.sops_file.opentofu.data[\"hetzner.nixos-anywhere-ssh.private-key\"]}";
        build_on_remote = true;

        flake = ".#\${hcloud_server.${hostname}.name}";

        target_port = "22";
        target_user = "root";

        extra_environment = {
          DECRYPTION_KEY = "\${data.sops_file.opentofu.data[\"${hostname}.sops\"]}";
        };

        extra_files_script = "${pkgs.writeScript "prepare-secrets" ''
          #!/usr/bin/env bash
          set -euo pipefail

          mkdir -p ./var/lib/sops-nix
          output_file="./var/lib/sops-nix/key.txt"

          echo "$DECRYPTION_KEY" > "$output_file"

          chmod 600 "$output_file"
        ''}";
      };
    })
    hetznerHosts;

  # resource."cloudflare_dns_record" =
  #   lib.mapAttrs
  #   (hostname: _host: {
  #     zone_id = "430d33cd2a5466368b1b1de14ab8a0db";
  #     name = "${hostname}.xm0se.dev";
  #     ttl = 1;
  #     type = "A";
  #     comment = "dns record for ${hostname} automaticly generated using terraform";
  #     content = "\${hcloud_server.${hostname}.ipv4_address}";
  #     proxied = true;
  #   })
  #   hetznerHosts;
}
