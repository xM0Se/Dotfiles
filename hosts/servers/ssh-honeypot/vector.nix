_: {
  services.vector = {
    enable = true;
    settings = {
      sources.cowrie = {
        type = "file";
        include = [
          "/var/lib/cowrie/log/cowrie/cowrie.json"
        ];
        read_from = "beginning";
        ignore_checkpoints = true;
      };

      transforms.parse = {
        type = "remap";
        inputs = [
          "cowrie"
        ];
        source = ''
          . = parse_json!(.message)
        '';
      };

      enrichment_tables.geoip = {
        type = "geoip";
        path = "/var/lib/GeoIP/GeoLite2-City.mmdb";
      };

      transforms.geoip = {
        type = "remap";
        inputs = ["parse"];
        source = ''
          geo = get_enrichment_table_record(
            "geoip",
            { "ip": .src_ip }
          ) ?? {}

          .geoip = {
            "city_name": geo.city_name,
            "country_name": geo.country_name,
            "country_code": geo.country_code,
            "continent_name": geo.continent_name,
            "latitude": geo.latitude,
            "longitude": geo.longitude,
          }
        '';
      };

      sinks.loki = {
        type = "loki";

        inputs = [
          "geoip"
        ];

        endpoint = "http://127.0.0.1:3100";

        encoding.codec = "json";

        labels = {
          job = "cowrie";
          host = "{{ hostname }}";
          filename = "{{ file }}";
        };
      };
    };
  };

  systemd.services.vector.serviceConfig = {
    Restart = "always";
    RestartSec = "10s";
  };
}
