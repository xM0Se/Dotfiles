{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./../modules/darwin/widgets.nix
    ./../modules/darwin/wallpaper.nix
    ./../modules/darwin/sops.nix
    ./../modules/common/vscode/vscodeconf.nix
    ./../modules/common/vesktop/default.nix
    ./../modules/common/zsh
    ./../modules/common/git.nix
    ./../modules/common/zen/default.nix
    ./../modules/darwin/sketchybar/default.nix
    ./../modules/darwin/aerospace/default.nix
    ./../modules/darwin/borders/default.nix
    ./../modules/darwin/ghostty/default.nix
    ./../modules/common/vicinae/default.nix
  ];

  vscodeconf.enable = true;
  zsh.enable = true;
  gitconf.enable = true;

  home = {
    # file = {
    #   "qmk_firmware/keyboards/crkbd/keymaps/custom".source = /Users/xm0se/dotfiles-for-humans/qmk;
    # };
    packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
