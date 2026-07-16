{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./atuin
    ./oh-my-posh
    ./pay-respects
    ./zoxide
    ./bat
    ./btop
    ./tmux
    ./fzf
    ./eza
    ./just
  ];

  options = {
    zsh.enable =
      lib.mkEnableOption "zsh";
  };

  config = lib.mkIf config.zsh.enable {
    fzf.enable = true;
    atuin.enable = true;
    oh-my-posh.enable = true;
    pay-respects.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    btop.enable = true;
    tmux.enable = true;
    eza.enable = true;
    just.enable = true;
    programs.zsh = {
      enable = true;
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      autosuggestion.enable = true;
      shellAliases = {
        c = "clear";
      };
    };
  };
}
