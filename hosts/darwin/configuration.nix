{
  inputs,
  self,
  pkgs,
  ...
}: {
  imports = [
    inputs.determinate.darwinModules.default
    inputs.mac-app-util.darwinModules.default
    (self + "/pkgs/homebrew")
    (self + "/configuration/configurations/darwin.nix")
  ];
  determinateNix.enable = true;

  brew = {
    mas.common.enable = false;
    font.common.enable = true;
    cask.common.enable = true;
  };

  home-manager.users.xm0se.imports = [
    (self + "/home/configurations/darwin.nix")
    (self + "/home/users/xm0se.nix")
  ];

  users.users.xm0se.home = "/Users/xm0se";

  environment.systemPackages = [
    inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
    #--
    pkgs.mas
    pkgs.age
    pkgs.sops
    #CLI tools
    pkgs.browsers
    pkgs.fastfetch
    pkgs.gh
    pkgs.cmatrix
    pkgs.nmap
    pkgs.dwt1-shell-color-scripts
    pkgs.ripgrep
    pkgs.whatsapp-for-mac
    pkgs.radicle-node # Includes `rad`, `radicle-node`, and related tools
    pkgs.radicle-httpd # HTTP API for web interfaces
    pkgs.radicle-explorer # Web frontend
    pkgs.radicle-tui # Terminal UI
    pkgs.radicle-desktop # Desktop app
    (pkgs.radicle-ci-broker.overrideAttrs (_: {
      # Radicle CI/CD
      doCheck = false;
    }))
    pkgs.tldr
    pkgs.tree
    pkgs.bitwarden-cli
    pkgs.obsidian
    pkgs.keycastr

    pkgs.gnupg
    pkgs.pinentry_mac
    pkgs.pcsc-tools
  ];

  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system = {
    primaryUser = "xm0se";
    defaults = {
      loginwindow = {
        SHOWFULLNAME = true;
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleIconAppearanceTheme = "RegularDark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit = "Celsius";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowShouldDragOnGesture = false;
        "com.apple.keyboard.fnState" = true;

        _HIHideMenuBar = true;
      };
      screencapture = {
        target = "clipboard";
        type = "jpg";
      };
      universalaccess.reduceMotion = true;

      WindowManager = {
        EnableTilingByEdgeDrag = false;
        EnableStandardClickToShowDesktop = false;
        EnableTopTilingByEdgeDrag = false;
        GloballyEnabled = false;
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };
    };

    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
