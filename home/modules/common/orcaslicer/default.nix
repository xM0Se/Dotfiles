# I have no clue if this works for initial configuration for orca-slicer gonna re image a PC soon to test
{
  pkgs,
  config,
  lib,
  ...
}: let
  settings = builtins.toJSON {
    app = {
      dark_color_mode = "1";
      default_page = "0";
      hide_login_side_panel = true;
      language = "en_US";
      region = "Europe";
      remember_printer_config = true;
      save_project_choise = "yes";
      show_daily_tips = false;
      show_gcode_window = true;
      show_hints = false;
      show_home_page = true;
      stealth_mode = true;
      user_mode = "expert";
    };

    filaments = [
      "eSUN PLA+ @System"
    ];

    firstguide = {
      finish = true;
    };

    header = "OrcaSlicer 2.4.2";

    local_machines = {
      "192.168.44.224" = {
        dev_ip = "192.168.44.224";
        dev_name = "192.168.44.224";
        printer_type = "Elegoo Neptune 4 Plus";
      };
    };

    models = [
      {
        model = "Elegoo Neptune 4 Plus";
        nozzle_diameter = "0.2;0.4;0.6;0.8;1.0";
        vendor = "Elegoo";
      }
    ];

    presets = {
      filaments = null;
      machine = "Elegoo Neptune 4 Plus 0.4 nozzle - Copy";
    };

    print = {
      bed_leveling = "1";
      flow_cali = "1";
      timelapse = "1";
    };
  };
  path =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "$HOME/Library/Application Support/OrcaSlicer/OrcaSlicer.conf"
    else "$HOME/.config/OrcaSlicer/OrcaSlicer.conf";
in {
  imports = [
  ];

  options = {
    orcaslicer.enable =
      lib.mkEnableOption "orcaslicer";
  };

  config = lib.mkIf config.orcaslicer.enable {
    home = {
      packages = [
        pkgs.orca-slicer
      ];
      activation.initialOrcaSlicerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -e "${path}" ]; then
          mkdir -p "$(dirname "${path}")"
          printf '%s\n' '${settings}' > "${path}"
        fi
      '';
    };
  };
}
