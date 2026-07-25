# WIP
{
  lib,
  config,
  ...
}: {
  sops = {
    secrets = {
      "crowdsec/enrollment_key" = {
        owner = "crowdsec";
        group = "crowdsec";
        restartUnits = ["crowdsec.service"];
      };
      "crowdsec/local_api_credentials/password" = {};
      "crowdsec/online_api_credentials/login" = {};
      "crowdsec/online_api_credentials/password" = {};
    };
    templates = {
      "crowdsec-local-api-creds.yaml" = {
        owner = "crowdsec";
        group = "crowdsec";
        mode = "0600";
        content = ''
          url: http://127.0.0.1:8080
          login: ssh-honeypot
          password: ${config.sops.placeholder."crowdsec/local_api_credentials/password"}
        '';
      };
      "crowdsec-online-api-creds.yaml" = {
        owner = "crowdsec";
        group = "crowdsec";
        mode = "0600";
        content = ''
          url: https://api.crowdsec.net/
          login: ${config.sops.placeholder."crowdsec/online_api_credentials/login"}
          password: ${config.sops.placeholder."crowdsec/online_api_credentials/password"}
        '';
      };
    };
  };
  users = {
    groups.crowdsec.gid = 992;
    users.crowdsec = {
      isSystemUser = true;
      uid = 992;
      group = "crowdsec";
    };
  };
  services.crowdsec = {
    enable = true;
    name = "ssh-honeypot";
    user = "crowdsec";
    group = "crowdsec";

    localConfig = {
      acquisitions = [
        {
          filenames = ["/var/lib/cowrie/log/cowrie/cowrie.json"];
          labels = {
            type = "cowrie";
            program = "cowrie";
          };
        }
      ];

      parsers.s01Parse = [
        {
          name = "local/cowrie";
          description = "Parse Cowrie JSON logs for ssh-bf";
          filter = "evt.Line.Labels.type == 'cowrie'";
          onsuccess = "next_stage";
          nodes = [
            {
              filter = "evt.Parsed.eventid == 'cowrie.login.failed'";

              statics = [
                {
                  meta = "log_type";
                  value = "ssh_auth";
                }
                {
                  meta = "auth_result";
                  value = "failed";
                }
                {
                  meta = "service";
                  value = "ssh";
                }
                {
                  meta = "source_ip";
                  expression = "evt.Parsed.src_ip";
                }
              ];
            }

            {
              filter = "evt.Parsed.eventid == 'cowrie.login.success'";

              statics = [
                {
                  meta = "log_type";
                  value = "ssh_auth";
                }
                {
                  meta = "auth_result";
                  value = "success";
                }
                {
                  meta = "service";
                  value = "ssh";
                }
                {
                  meta = "source_ip";
                  expression = "evt.Parsed.src_ip";
                }
              ];
            }
          ];
        }
      ];
      scenarios = [
        {
          name = "local/cowrie-ssh-bruteforce";
          description = "Detect SSH brute force against a Cowrie honeypot";

          type = "leaky";

          filter = ''
            evt.Meta.log_type == "ssh_auth"
          '';

          groupby = "evt.Meta.source_ip";

          capacity = 5;
          leakspeed = "1m";
          blackhole = "30m";

          labels = {
            service = "ssh";
            behavior = "ssh:bruteforce";
            remediation = true;
            confidence = 3;
            spoofable = 1;
            classification = [
              "attack.T1110"
            ];
          };
        }
      ];
    };

    settings = {
      lapi = {
        credentialsFile = config.sops.templates."crowdsec-local-api-creds.yaml".path;
      };
      capi = {
        credentialsFile = config.sops.templates."crowdsec-online-api-creds.yaml".path;
      };

      console = {
        tokenFile = config.sops.secrets."crowdsec/enrollment_key".path;
        configuration = {
          console_management = true;
        };
      };

      general = {
        api = {
          server = {
            enable = true;
            listen_uri = "127.0.0.1:8080";
          };
        };
      };
    };
  };

  systemd.services.crowdsec.serviceConfig = {
    DynamicUser = lib.mkForce false;

    User = "crowdsec";
    Group = "crowdsec";

    StateDirectory = "crowdsec";
    StateDirectoryMode = "0755";
    ReadWritePaths = ["/var/lib/crowdsec"];
  };
}
