{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    git.enable =
      lib.mkEnableOption "enables git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "xM0Se";
          email = "git@xM0Se.dev";
          signingKey = "4A5978B7AF158629E93E571EF672D852B24EEB14";
        };
        alias = {
          cm = "commit -m";
          co = "checkout";
          sw = "switch";
          br = "branch";
          ci = "commit";
          ca = "commit --amend";
          aa = "add --all";
          a = "add .";
          unstage = "reset HEAD --";
          pl = "pull";
          ps = "push";
          l = "log --oneline";
          lg = "log --oneline --graph --decorate";
          last = "log -1 HEAD";
          st = "status";
        };
      };
      ignores = [
        "*.swp"
        "*.DS_Store"
      ];
      signing = {
        key = "4A5978B7AF158629E93E571EF672D852B24EEB14";
        signByDefault = true;
      };
    };

    home.packages = [
      pkgs.pcsc-tools
    ];

    services.gpg-agent.enableSshSupport = true;
  };
}
