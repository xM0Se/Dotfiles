{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    "grafana/secret_key" = {
      owner = "grafana";
      group = "grafana";
      mode = "0400";
    };
    "grafana/admin/password" = {
      owner = "grafana";
      group = "grafana";
      mode = "0400";
    };
    "grafana/admin/email" = {
      owner = "grafana";
      group = "grafana";
      mode = "0400";
    };
  };

  # environment.etc."grafana/dashboards/admin-dashboard.yaml".source = ./admin-dashboard.yaml;

  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };
      security = {
        secret_key = "$__file{${config.sops.secrets."grafana/secret_key".path}}";
        admin_email = "$__file{${config.sops.secrets."grafana/admin/email".path}}";
        admin_password = "$__file{${config.sops.secrets."grafana/admin/password".path}}";
      };
    };

    declarativePlugins = with pkgs.grafanaPlugins; [volkovlabs-echarts-panel];

    provision = {
      enable = true;

      # dashboards.path = "/etc/grafana/dashboards";

      datasources.settings = {
        apiVersion = 1;

        datasources = [
          {
            name = "Loki";
            uid = "loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:3100";
            isDefault = true;
            editable = false;

            jsonData = {
              maxLines = 100000;
            };
          }
        ];
      };
    };
  };
}
