{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        # Crucial vertical settings
        layer = "top";
        position = "left";
        width = 60; # Defines horizontal thickness of the vertical bar
        margin-top = 10;
        margin-bottom = 10;
        margin-left = 10;
        margin-right = 10;

        modules-left = [
          "clock#I"
          "clock#M"
          "clock#p"

          "custom/separator"

          "clock#a"
          "clock#d"
          "clock#b"

          "custom/separator"

          "hyprland/workspaces"

          "custom/separator"
        ];
        modules-center = [];
        modules-right = [
          "custom/separator"

          "pulseaudio"
          "pulseaudio#microphone"

          "custom/separator"

          "network"

          "custom/separator"

          "custom/memory"
          "memory"

          "custom/cpu"
          "cpu"

          "custom/separator"

          "custom/nixos"
        ];

        "custom/separator" = {
          tooltip = false;
          format = "───────";
        };

        #Clock (split out because I can't figure out how to change the size independently :)
        "clock#I" = {
          tooltip = false;
          format = "{:%I}";
        };
        "clock#M" = {
          tooltip = false;
          format = "{:%M}";
        };
        "clock#p" = {
          tooltip = false;
          format = "{:%p}";
        };

        #Date (split out because I can't figure out how to center it otherwise :)
        "clock#a" = {
          tooltip = false;
          format = "{:%a}";
        };
        "clock#d" = {
          tooltip = false;
          format = "{:%d}";
        };
        "clock#b" = {
          tooltip = false;
          format = "{:%b}";
        };

        "hyprland/workspaces" = {
          tooltip = false;
          format = "{icon}";
          orientation = "vertical";
          on-click = "activate";
          on-scroll-up = "none";
          on-scroll-down = "none";
        };

        "pulseaudio" = {
          tooltip = false;
          format = "{icon}";
          format-muted = " ";
          format-icons = {
            default = [" " " " " "];
          };
        };
        "pulseaudio#microphone" = {
          tooltip = false;
          format-source = " ";
          format-source-muted = " ";
        };

        "custom/cpu" = {
          tooltip = false;
          format = " ";
        };
        "cpu" = {
          tooltip = false;
          format = "{usage}%";
        };

        "custom/memory" = {
          tooltip = false;
          format = " ";
        };
        "memory" = {
          tooltip = false;
          format = "{percentage}%";
        };

        "custom/nixos" = {
          tooltip = false;
          format = " ";
        };
      };
    };

    style = ''
      window#waybar {
        color: #e0def4;
        background-color: #2a273f;
        border: 2px solid #393552;
        border-radius: 12px;

        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }

      #custom-separator {
        color: #e0def4;
        font-size: 9px;
        margin: 9px;
      }

      #custom-nixos {
        padding-bottom: 15px;
      }

      #clock.I {
        padding-top: 5px;
        font-size: 30px;
      }

      #clock.M {
        padding-top: 0px;
        font-size: 22px;
      }

      #clock.p {
        font-size: 12px;
      }

      #pulseaudio, #network{
        margin: 10px 0;
      }

      #workspaces button {
        background: transparent;
        border: none;
        padding: 0px 4px;
        margin: 0;
        box-shadow: none;
        text-shadow: none;
        border-radius: 0;

        color: #595959;
      }

      #workspaces button.active {
        color: #33ccee;
        background: transparent;
      }

      #workspaces button:hover {
        background: transparent;
        color: #33ccee;
        box-shadow: none;
      }
    '';
  };
}
