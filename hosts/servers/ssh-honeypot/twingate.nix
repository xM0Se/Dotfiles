{config, ...}: {
  sops = {
    secrets = {
      "twingate/accessToken" = {};
      "twingate/refreshToken" = {};
    };
    templates."twingate-env".content = ''
      TWINGATE_ACCESS_TOKEN=${config.sops.placeholder."twingate/accessToken"}
      TWINGATE_REFRESH_TOKEN=${config.sops.placeholder."twingate/refreshToken"}
    '';
  };

  virtualisation.oci-containers.containers.twingate-connector = {
    image = "twingate/connector:latest";

    environment = {
      TWINGATE_NETWORK = "xmose";
      TWINGATE_LABEL_HOSTNAME = "ssh-honeypot";
    };

    extraOptions = [
      "--network=host"
    ];

    environmentFiles = [
      config.sops.templates."twingate-env".path
    ];

    autoStart = true;
  };
}
