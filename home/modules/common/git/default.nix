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
    programs = {
      git = {
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

      gpg = {
        enable = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800; # 30min
      maxCacheTtl = 7200; # 2h
      enableSshSupport =
        if pkgs.stdenv.hostPlatform.isDarwin
        then true
        else false;
      pinentry.package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.pinentry_mac
        else pkgs.pinentry-curses;
    };
  };
}
