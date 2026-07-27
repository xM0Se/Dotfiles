_: {
  variable."state_passphrase" = {
    type = "string";
    sensitive = true;
  };

  terraform.encryption = {
    key_provider."pbkdf2"."my_passphrase".passphrase = "\${var.state_passphrase}";

    method."aes_gcm"."default".keys = "key_provider.pbkdf2.my_passphrase";

    state = {
      method = "method.aes_gcm.default";
      enforced = true;
    };
  };
}
