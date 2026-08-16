{
  self,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./../modules/common/vesktop
    ./../modules/common/zsh
    ./../modules/common/git
    ./../modules/common/zen
    ./../modules/common/sops
    ./../modules/common/vicinae
    ./../modules/common/radicle
    ./../modules/common/ghostty
    ./../modules/common/neru
    ./../modules/nixos/hyprland
  ];

  git.enable = true;
  radicle.enable = true;
  sops.enable = true;
  ghostty.enable = true;

  home = {
    packages = [
      inputs.colmena.packages.${pkgs.stdenv.hostPlatform.system}.colmena
      pkgs.sops
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
