{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    eza.enable =
      lib.mkEnableOption "eza";
  };
  config = lib.mkIf config.eza.enable {
    programs = {
      eza = {
        enable = true;
        package = pkgs.eza;
        enableZshIntegration = true;
      };
      zsh.shellAliases = {
        lt = "eza --color=always --group-directories-first --git --no-time --icons=always --all --tree --ignore-glob  '.DS_Store'";
        ls = "eza --color=always --grid --long --no-time --git --icons=always --no-user --no-permissions --color-scale-mode=gradient --all --group-directories-first --ignore-glob  '.DS_Store'";
        ll = "eza --color=always --long --git --icons=always --color-scale-mode=gradient --total-size --show-symlinks --all --group-directories-first --ignore-glob  '.DS_Store'";
      };
    };
  };
}
