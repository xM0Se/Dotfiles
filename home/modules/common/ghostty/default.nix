{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./shaders.nix
  ];

  options = {
    ghostty.enable =
      lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package =
        if pkgs.stdenv.isDarwin
        then pkgs.ghostty-bin
        else pkgs.ghostty;

      enableZshIntegration = true;
      settings = {
        mouse-hide-while-typing = true;
        copy-on-select = true;
        keybind = [
          "global:cmd+t+shift=toggle_quick_terminal"
          ''option+backspace=text:\x17''
        ];
        theme = "Rose Pine Moon";
        macos-titlebar-style = "hidden";
      };
    };
  };
}
