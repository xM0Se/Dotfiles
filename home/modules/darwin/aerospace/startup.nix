{pkgs, ...}: {
  programs.aerospace.settings.after-startup-command = [
    "exec-and-forget /etc/profiles/per-user/xm0se/bin/vicinae server --replace"
    ''exec-and-forget open -a "Ghostty"''
    "exec-and-forget /etc/profiles/per-user/xm0se/bin/zen-beta"
    "exec-and-forget ${pkgs.sketchybar}/bin/sketchybar --reload"
  ];
}
