{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    fzf.enable =
      lib.mkEnableOption "fzf";
  };
  config = lib.mkIf config.fzf.enable {
    programs = {
      fzf = {
        enable = true;
        package = pkgs.fzf;
        enableZshIntegration = true;
      };
      zsh.shellAliases = {
        fzf = "fzf --preview 'bat --style=numbers,changes --color=always --theme=RosePineMoon {}' --preview-window=right:60%";
        nzf = "fzf --preview 'bat --style=numbers,changes --color=always --theme=RosePineMoon {}' --preview-window=right:60% | xargs -r nvim";
      };
    };
  };
}
