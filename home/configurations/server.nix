{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./../modules/common/zsh
    ./../modules/common/git.nix
    ./../modules/nixos/sops.nix
  ];

  zsh.enable = true;
  gitconf.enable = true;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      PAGER = "bat";
    };

    packages = [
      pkgs.hello
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];

    stateVersion = "25.05";
  };
}
