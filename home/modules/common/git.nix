{
  lib,
  config,
  ...
}: {
  options = {
    gitconf.enable =
      lib.mkEnableOption "enables gitconf";
  };

  config = lib.mkIf config.gitconf.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "xm0se";
          email = "189546389+xM0Se@users.noreply.github.com";
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
  };
}
