{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
    systemd.enable = false;
    plugins = [
    ];
    configType = "lua";
    settings = let
      workspaces = ["B" "T"];
      terminal = lib.getExe pkgs.ghostty;
      editor = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
    in {
      mod = {
        _var = "ALT";
      };

      on = let
        cmd = command: {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function()\n hl.exec_cmd(\"${command}\")\nend")
          ];
        };
      in [
        (cmd "vicinae server")
        (cmd "neru launch")
        (cmd "waybar")
      ];

      layer_rule = [
        {
          match = {namespace = "vicinae";};
          name = "vicinae-blur";
          blur = true;
          ignore_alpha = 0;
        }
        {
          match = {namespace = "vicinae";};
          name = "vicinae-no-animation";
          no_anim = true;
        }
      ];

      bind = let
        bind = key: command: {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + ${key}\"")
            (lib.generators.mkLuaInline "hl.dsp.${command}")
          ];
        };
      in
        [
          (bind "SPACE" "exec_cmd(\"vicinae toggle\")")
          (bind "RETURN" "exec_cmd(\"${terminal}\")")
          (bind "V" "exec_cmd(\"${terminal} -e ${editor}\")")
          (bind "G" "exec_cmd(\"neru recursive_grid\")")
          (bind "Q" "window.close()")
          (bind "F" "window.fullscreen()")

          (bind "H" "focus({ direction = \"left\" })")
          (bind "L" "focus({ direction = \"right\" })")
          (bind "K" "focus({ direction = \"up\" })")
          (bind "J" "focus({ direction = \"down\" })")
          (bind "SHIFT + H" "window.swap({ direction = \"left\"})")
          (bind "SHIFT + L" "window.swap({ direction = \"right\"})")
          (bind "SHIFT + K" "window.swap({ direction = \"up\"})")
          (bind "SHIFT + J" "window.swap({ direction = \"down\"})")
        ]
        ++ builtins.concatLists (
          map
          (workspace: [
            (bind "${toString workspace}" "focus({ workspace = \"name:${toString workspace}\" })")
            (bind "SHIFT + ${toString workspace}" "window.move({ workspace = \"name:${toString workspace}\" })")
          ])
          workspaces
        );

      config = {
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          key_press_enables_dpms = true;
        };
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };
    };
  };
}
