{pkgs, ...}: let
  themeRepo = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "discord";
    rev = "HEAD";
    sha256 = "sha256-pwiFCJClOl5IvnbnT/bZtshK3nEAq7bdXtEdnHcTFIk=";
  };
  themePath = "dist/rose-pine-moon.css";
  theme = builtins.readFile "${themeRepo}/${themePath}";
in {
  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop;
    vencord = {
      themes = {
        theme = "${theme}";
      };
      settings = {
        enabledThemes = ["theme.css"];
      };
    };
  };
}
