{
  self,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../modules/common/vscode
    ./../modules/common/vesktop
    ./../modules/common/zsh
    ./../modules/common/git
    ./../modules/common/zen
    ./../modules/common/sops
    ./../modules/common/vicinae
    ./../modules/common/radicle
    ./../modules/common/ghostty
    ./../modules/darwin/sketchybar
    ./../modules/darwin/aerospace
    ./../modules/darwin/widgets.nix
    ./../modules/darwin/wallpaper.nix
    ./../modules/darwin/borders
  ];

  vscode.enable = false;
  zsh.enable = true;
  git.enable = true;
  radicle.enable = true;
  sops.enable = true;
  ghostty.enable = true;

  home = {
    # file = {
    #   "qmk_firmware/keyboards/crkbd/keymaps/custom".source = /Users/xm0se/dotfiles-for-humans/qmk;
    # };
    packages = [
      inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
      pkgs.sops
      pkgs.obsidian
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim

      pkgs.pinentry-mac # for git commit singing
    ];

    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
