{inputs, ...}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ./casks
    ./fonts
    ./mas
  ];
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "xm0se";
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
