#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    pacman -S --noconfirm zsh zsh-completions tmux neovim ttf-jetbrains-mono-nerd
    chsh -s /usr/bin/zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install tmux neovim font-jetbrains-mono-nerd-font
else
    return 1
fi

curl -sS https://starship.rs/install.sh | sh -s -- -f

base_path=$( realpath "$0"  )
base_path=$( dirname "$base_path" )

ln -s "$base_path"/nvim ~/.config/ 

mkdir ~/.local/scripts
chmod +x "$base_path"/tmux/tmux-sessionizer
ln -s "$base_path"/tmux/tmux-sessionizer ~/.local/scripts

ln -s "$base_path"/tmux/.tmux.config ~/

mkdir ~/.cache/zsh
ln -s "$base_path"/zsh/.zshrc ~/
