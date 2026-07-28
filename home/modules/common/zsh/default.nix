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
    ./fastfetch
  ];

  options = {
    zsh.enable =
      lib.mkEnableOption "zsh";
  };

  config = lib.mkIf config.zsh.enable {
    atuin.enable =
      lib.mkDefault true;
    oh-my-posh.enable =
      lib.mkDefault true;
    pay-respects.enable =
      lib.mkDefault true;
    zoxide.enable =
      lib.mkDefault true;
    bat.enable =
      lib.mkDefault true;
    btop.enable =
      lib.mkDefault true;
    tmux.enable =
      lib.mkDefault true;
    fzf.enable =
      lib.mkDefault true;
    eza.enable =
      lib.mkDefault true;
    just.enable =
      lib.mkDefault true;
    fastfetch.enable =
      lib.mkDefault true;

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
