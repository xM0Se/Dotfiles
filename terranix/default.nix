_: {
  imports = [
    ./hetzner.nix
  ];

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
        version = "1.4.1";
      };

      # cloudflare = {
      #   source = "cloudflare/cloudflare";
      #   version = "5.22.0";
      # };
    };
  };

  data.sops_file.opentofu.source_file = "../../secrets/secrets.yaml";

  # provider.cloudflare.api_token = "\${data.sops_file.opentofu.data[\"cloudflare.api\"]}";

  # resource = {
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
  # };
}
