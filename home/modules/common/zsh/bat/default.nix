{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    bat.enable =
      lib.mkEnableOption "bat";
  };
  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      themes = {
        RosePineMoon = {
          src = pkgs.fetchFromGitHub {
            owner = "drluckyspin";
            repo = "rose-pine-bat";
            rev = "c0bfb1fda311159397031cbf07411a6349b49e32";
            sha256 = "sha256-p0AR47OtBcQyyGJOjf+EjRQw0ckyUhcdeRqb7sA0zLI=";
          };
          file = "themes/Rose-Pine-Moon.tmTheme";
        };
      };
      config = {
        theme = "RosePineMoon";
      };
    };
  };
}
