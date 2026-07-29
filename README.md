# This Is a GitHub Repo of My Dotfiles

Theme = Rosé Pine Moon  
Font = JetBrains Mono  
Window manager = aerospace  
Border = SketchyBar  
Text Editor = Neovim  
Terminal multiplexer = Tmux  
Terminal = Ghossty  
Package manager = Nix, homebrew

<img width="3440" height="1440" alt="macOS-setup" src="https://github.com/user-attachments/assets/3bb381b9-9277-40ed-9bd6-c8bc85f28e53" />

## Installation Instructions MacOS

> [!WARNING]
> You have to give Terminal full disk access before executing.

```zsh
git clone https://github.com/xM0Se/dotfiles.git
```

```zsh
cd dotfiles
```

```zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
```

```zsh
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

```zsh
sudo nix run nix-darwin#darwin-rebuild -- switch --flake ~/dotfiles#dMACOS
```

Afterward you can use `j build` when in the dotfiles directory
