_: {
  terraform.required_providers.sops = {
    source = "carlpett/sops";
    version = "1.4.1";
  };
  data.sops_file.opentofu.source_file = "../../secrets/secrets.yaml";
}
