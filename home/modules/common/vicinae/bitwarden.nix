{
  inputs,
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "bitwarden/client_id" = {mode = "0600";};
    "bitwarden/client_secret" = {mode = "0600";};
  };

  home.file.".local/bin/bw-vicinae-wrapper" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      export BW_CLIENTID="$(< "${config.sops.secrets."bitwarden/client_id".path}")"
      export BW_CLIENTSECRET="$(< "${config.sops.secrets."bitwarden/client_secret".path}")"
      exec ${pkgs.bitwarden-cli}/bin/bw "$@"
    '';
  };

  programs.vicinae = {
    extensions = [
      (inputs.vicinae.lib.${pkgs.stdenv.hostPlatform.system}.mkRayCastExtension {
        name = "bitwarden";
        rev = "refs/heads/main";
        sha256 = "sha256-kSIfQcnAZuwT9ipXOJR3nMLlwS4OXX03mP5jX1ktwnw=";
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r ./* $out/
          cp -r $TMPDIR/.config/raycast/extensions/bitwarden/* $out/
          runHook postInstall
        '';
        postPatch = ''
          sed -i -E '/"name": "client(Id|Secret)"/{N;s/"type": "password"/"type": "textfield"/;}' package.json #This changes the type of client id/secret to be a textfield so it can be changed via the viciane config file.
        '';
      })
    ];
    settings.providers."@jomifepe/bitwarden" = {
      preferences = {
        fetchFavicons = true;
        repromptIgnoreDuration = "900000";
        serverUrl = "";
        shouldCacheVaultItems = true;
        syncOnLaunch = true;
        windowActionOnCopy = "close";
        cliPath = "${config.home.homeDirectory}/.local/bin/bw-vicinae-wrapper";
        clientId = "clientId"; #These are dummy values that must be set so vicinae does not ask for client id/secret.
        clientSecret = "clientSecret"; #These are dummy values that must be set so vicinae does not ask for client id/secret.
      };
      entrypoints = {
        search.preferences = {
          primaryAction = "showDetails";
          transientCopySearch = "passwords";
        };
        generate-password-quick.enabled = false;
        generate-password.enabled = false;
        create-folder.enabled = false;
        authenticator.enabled = false;
        logout-vault.enabled = false;
        create-login.enabled = false;
        receive-send.enabled = false;
        search-sends.enabled = false;
        create-send.enabled = false;
      };
    };
  };
}
