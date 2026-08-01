{self, ...}: {
  imports = [
    (self + "/pkgs/homebrew")
    (self + "/configuration/configurations/darwin.nix")
  ];

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

  system = {
    primaryUser = "xm0se";
    defaults = {
      loginwindow = {
        SHOWFULLNAME = true;
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleIconAppearanceTheme = "RegularDark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowShouldDragOnGesture = false;
        _HIHideMenuBar = true;
      };

      WindowManager = {
        EnableTilingByEdgeDrag = false;
        EnableStandardClickToShowDesktop = false;
        EnableTopTilingByEdgeDrag = false;
        GloballyEnabled = false;
      };

      universalaccess.reduceMotion = true;
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    };

    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };
}
