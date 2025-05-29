#!/bin/bash

common_deps=(tmux neovim ttf-jetbrains-mono-nerd fzf)
linux_deps=(zsh zsh-completions ${common_deps[*]})
macos_deps=(${common_deps[*]})

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running Linux init\n"
    echo "-- Installing dependencies\n"
    if command -v pacman 2>&1 >/dev/null
    then
        pacman -S --noconfirm "${linux_deps[*]}"
    elif command -v pacman 2>&1 >/dev/null
    then
        apt-get install -y "${linux_deps[*]}"
    else
        echo "Could not find supported package manager\n"
        exit 1
    fi
    echo "-- Setting default shell to zsh\n"
    chsh -s /usr/bin/zsh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running MacOS init\n"
    echo "-- Checking xcode-select\n"
    if ! command -v xcode-select 2>&1 >/dev/null
    then
        echo "xcode-select not installed. running installer\n"
        echo "Rerun init after it has installed\n"
        exit 1
    fi
    echo "-- Installing dependencies\n"
    brew install "${macos_deps[*]}"
else
    echo "Unsupported OS\n"
    exit 1
fi

echo "-- Installing starship zsh theme\n"
curl -sS https://starship.rs/install.sh | sh -s -- -f

base_path=$( realpath "$0"  )
base_path=$( dirname "$base_path" )

echo "-- Linking config files\n"

echo "---- Neovim: $base_path/nvim -> $HOME/.config\n"
ln -s "$base_path"/nvim "$HOME"/.config

mkdir "$HOME"/.local/scripts
chmod +x "$base_path"/tmux/tmux-sessionizer
echo "---- Tmux sessionizer: $base_path/tmux/tmux-sessionizer -> $HOME/.local/scripts\n"
ln -s "$base_path"/tmux/tmux-sessionizer "$HOME"/.local/scripts

echo "---- Tmux config: $base_path/tmux/.tmux.config -> $HOME\n"
ln -s "$base_path"/tmux/.tmux.config "$HOME"

mkdir ~/.cache/zsh
echo "---- ZSH: $base_path/zsh/.zshrc -> $HOME\n"
ln -s "$base_path"/zsh/.zshrc "$HOME"
