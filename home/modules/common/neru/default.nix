{inputs, ...}: {
  imports = [
    inputs.neru.homeManagerModules.default
  ];

  nixpkgs.overlays = [
    inputs.neru.overlays.default
  ];

  services.neru = {
    enable = true;
    settings = {
      hotkeys = {
        "Ctrl+F" = "recursive_grid --cursor-selection-mode hold";
        "Primary+Shift+Space" = "hints left_click";
        "Primary+Shift+G" = "grid left_click";
        "Primary+Shift+K" = "recursive_grid left_click";
      };
      recursive_grid = {
        enabled = true;
        grid_cols = 3;
        grid_rows = 3;
        keys = "arstgneio";
        min_size_width = 1;
        min_size_height = 1;
        max_depth = 2;
      };
      recursive_grid.animation = {
        enabled = true;
      };
      recursive_grid.ui = {
        font_family = "JetBrainsMonoNLNFP-Bold";
        line_width = 1;
        # highlight_color = "#00000000";
        # text_color = "#00000000";
      };
      recursive_grid.hotkeys = {
        # disable defaults
        "shift+l" = "__disabled__";
        "Shift+M" = "__disabled__";
        "Shift+I" = "__disabled__";
        "Shift+U" = "__disabled__";
        "Shift+R" = "__disabled__";
        "`" = "__disabled__";
        "Tab" = "toggle-cursor-follow-selection";

        "," = "action move_mouse --center";
        "." = "action reset";
        "p" = "action left_click --toggle";
        "space" = "action left_click";
        "i" = "action move_mouse";
        "u" = "action left_click";
        "e" = "action middle_click";
        "o" = "action right_click";

        "Ctrl+C" = "idle";
        "Ctrl+J" = "action scroll_down";
        "Ctrl+K" = "action scroll_up";
        "Ctrl+H" = "action scroll_left";
        "Ctrl+L" = "action scroll_right";
        "Ctrl+S" = "macro move_and_scroll";

        "Shift+H" = "action move_cell --direction left";
        "Shift+L" = "action move_cell --direction right";
        "Shift+K" = "action move_cell --direction up";
        "Shift+J" = "action move_cell --direction down";
      };
      general = {
        excluded_apps = ["com.apple.Terminal"];
      };
    };
  };
}
