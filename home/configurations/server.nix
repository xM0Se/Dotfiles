{
  pkgs,
  self,
  ...
}: {
  imports = [
    ../modules/common/zsh
    ../modules/common/git
    ../modules/common/sops
  ];

  zsh.enable = true;
  git.enable = true;
  sops.enable = true;

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
