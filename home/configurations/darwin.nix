{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
    inputs.mac-app-util.homeManagerModules.default
    ./../modules/darwin/widgets.nix
    ./../modules/darwin/wallpaper.nix
    ./../modules/common/sops.nix
    ./../modules/common/vscode/vscodeconf.nix
    # ./../modules/common/vesktop/default.nix
    ./../modules/common/zsh/zsh.nix
    ./../modules/common/git.nix
    ./../modules/common/zen/default.nix
    ./../modules/darwin/sketchybar/default.nix
    ./../modules/darwin/aerospace/default.nix
    ./../modules/darwin/borders/default.nix
    ./../modules/darwin/ghostty/default.nix
    ./../modules/common/vicinae/hidden_mac.nix
  ];

  vscodeconf.enable = true;
  zshconf.enable = true;
  gitconf.enable = true;

  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      pop_to_root_on_close = true;
      escape_key_behavior = "close_window";
      font.normal.family = "JetBrains Mono";
      theme.dark.name = "rose-pine-moon";
      launcher_window = {
        compact_mode.enabled = true;
        material = "blur";
      };
    };
  };

  home = {
    packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvimconf
    ];
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };
    # file = {
    #   "qmk_firmware/keyboards/crkbd/keymaps/custom".source = /Users/xm0se/dotfiles-for-humans/qmk;
    # };
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
