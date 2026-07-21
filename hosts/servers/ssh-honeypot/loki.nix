_: {
  services.loki = {
    enable = true;

    configuration = {
      query_scheduler = {
        grpc_client_config = {
          max_recv_msg_size = 33554432;
          max_send_msg_size = 33554432;
        };
      };

      frontend = {
        compress_responses = true;
        grpc_client_config = {
          max_recv_msg_size = 33554432;
          max_send_msg_size = 33554432;
        };
      };

      frontend_worker = {
        grpc_client_config = {
          max_recv_msg_size = 33554432;
          max_send_msg_size = 33554432;
        };
      };

      limits_config = {
        max_query_series = 100000;
        max_entries_limit_per_query = 20000;
      };

      auth_enabled = false;

      server.http_listen_port = 3100;

      common = {
        path_prefix = "/var/lib/loki";
        replication_factor = 1;

        ring.kvstore.store = "inmemory";
      };

      schema_config.configs = [
        {
          from = "2025-01-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";

          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];
    };
  };
}
