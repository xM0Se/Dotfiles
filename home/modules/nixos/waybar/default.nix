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
          format = "───────";
          tooltip = false;
        };

        #Clock (split out because I can't figure out how to change the size independently :)
        "clock#I" = {
          format = "{:%I}";
        };
        "clock#M" = {
          format = "{:%M}";
        };
        "clock#p" = {
          format = "{:%p}";
        };

        #Date (split out because I can't figure out how to center it otherwise :)
        "clock#a" = {
          format = "{:%a}";
        };
        "clock#d" = {
          format = "{:%d}";
        };
        "clock#b" = {
          format = "{:%b}";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          orientation = "vertical";
          tooltip = false;
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = " ";
          format-icons = {
            default = [" " " " " "];
          };
        };
        "pulseaudio#microphone" = {
          format-source = " ";
          format-source-muted = " ";
        };

        "custom/cpu" = {
          format = " ";
        };
        "cpu" = {
          format = "{usage}%";
        };

        "custom/memory" = {
          format = " ";
        };
        "memory" = {
          format = "{percentage}%";
        };

        "custom/nixos" = {
          format = " ";
          tooltip = false;
        };
      };
    };

    style = ''
      /* Essential styling tweaks for vertical layout */
      window#waybar {
        color: #e0def4;
        background-color: #2a273f;
        border: 1px solid #393552;
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
        font-size: 30px;
      }

      #clock.M {
        font-size: 22px;
      }

      #clock.p {
        font-size: 12px;
      }

      #pulseaudio, #network{
        margin: 10px 0;
      }
    '';
  };
}
