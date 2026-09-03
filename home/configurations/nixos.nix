{
  self,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../modules/common/vesktop
    ../modules/common/zsh
    ../modules/common/git
    ../modules/common/zen
    ../modules/common/sops
    ../modules/common/vicinae
    ../modules/common/radicle
    ../modules/common/ghostty
    ../modules/common/neru
    ../modules/common/wallpaper
    ../modules/nixos/hyprland
    ../modules/nixos/waybar
    ../modules/nixos/hyprlock
  ];

  git.enable = true;
  vicinae.enable = true;
  radicle.enable = true;
  sops.enable = false;
  ghostty.enable = true;
  zsh.enable = true;
  wallpaper.enable = true;

  sops = {
    defaultSopsFile = "${self}/secrets/nixos-test.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };

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
