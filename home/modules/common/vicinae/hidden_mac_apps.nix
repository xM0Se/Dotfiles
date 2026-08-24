{
  lib,
  config,
  ...
}: {
  options = {
    vicinae.hidden-mac-apps.enable =
      lib.mkEnableOption "hidden-mac-apps";
  };

  config = lib.mkIf config.vicinae.hidden-mac-apps.enable {
    programs.vicinae.settings.providers.applications.entrypoints = {
      "com.apple.AboutThisMacLauncher".enabled = false;
      "com.apple.AppStore".enabled = false;
      "com.apple.Automator".enabled = false;
      "com.apple.BluetoothFileExchange".enabled = false;
      "com.apple.Chess".enabled = false;
      "com.apple.ColorSyncUtility".enabled = false;
      "com.apple.Console".enabled = false;
      "com.apple.DVDPlayer".enabled = false;
      "com.apple.DeskCam".enabled = false;
      "com.apple.Dictionary".enabled = false;
      "com.apple.DigitalColorMeter".enabled = false;
      "com.apple.DirectoryUtility".enabled = false;
      "com.apple.DiskUtility".enabled = false;
      "com.apple.ExpansionSlotUtility".enabled = false;
      "com.apple.FolderActionsSetup".enabled = false;
      "com.apple.GenerativePlaygroundApp".enabled = false;
      "com.apple.Home".enabled = false;
      "com.apple.IPAInstaller".enabled = false;
      "com.apple.Image_Capture".enabled = false;
      "com.apple.Magnifier".enabled = false;
      "com.apple.MigrateAssistant".enabled = false;
      "com.apple.Music".enabled = false;
      "com.apple.Notes".enabled = false;
      "com.apple.PhotoBooth".enabled = false;
      "com.apple.ScreenContinuity".enabled = false;
      "com.apple.ScriptEditor2".enabled = false;
      "com.apple.Stickies".enabled = false;
      "com.apple.SystemProfiler".enabled = false;
      "com.apple.TV".enabled = false;
      "com.apple.TextEdit".enabled = false;
      "com.apple.Ticket-Viewer".enabled = false;
      "com.apple.VoiceOverUtility".enabled = false;
      "com.apple.appleseed.FeedbackAssistant".enabled = false;
      "com.apple.apps.launcher".enabled = false;
      "com.apple.archiveutility".enabled = false;
      "com.apple.audio.AudioMIDISetup".enabled = false;
      "com.apple.backup.launcher".enabled = false;
      "com.apple.bootcampassistant".enabled = false;
      "com.apple.exposelauncher".enabled = false;
      "com.apple.finder.Open-AirDrop".enabled = false;
      "com.apple.finder.Open-AllMyFiles".enabled = false;
      "com.apple.finder.Open-Computer".enabled = false;
      "com.apple.finder.Open-Network".enabled = false;
      "com.apple.finder.Open-Recents".enabled = false;
      "com.apple.finder.Open-iCloudDrive".enabled = false;
      "com.apple.freeform".enabled = false;
      "com.apple.games".enabled = false;
      "com.apple.grapher".enabled = false;
      "com.apple.helpviewer".enabled = false;
      "com.apple.iBooksX".enabled = false;
      "com.apple.keychainaccess".enabled = false;
      "com.apple.mail".enabled = false;
      "com.apple.mobilephone".enabled = false;
      "com.apple.news".enabled = false;
      "com.apple.printcenter".enabled = false;
      "com.apple.shortcuts".enabled = false;
      "com.apple.siri.launcher".enabled = false;
      "com.apple.stocks".enabled = false;
      "com.apple.wifi.diagnostics".enabled = false;
    };
  };
}
