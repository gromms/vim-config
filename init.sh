#!/bin/bash

common_deps=(tmux neovim ttf-jetbrains-mono-nerd fzf)
linux_deps=(zsh zsh-completions ${common_deps[@]})
macos_deps=(${common_deps[@]})

home="${XDG_CACHE_HOME:-$HOME}"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running Linux init\n"
    echo "-- Installing dependencies\n"
    if command -v pacman 2>&1 >/dev/null
    then
        echo "Arch"
        sudo pacman -S --noconfirm "${linux_deps[@]}"
    elif command -v pacman 2>&1 >/dev/null
    then
        sudo apt-get install -y "${linux_deps[@]}"
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
    echo "-- Setting zsh permissions"
    chmod g-w,o-w /usr/local/share/zsh/site-functions
    chmod g-w,o-w /usr/local/share/zsh
else
    echo "Unsupported OS\n"
    exit 1
fi

echo "Checking for tpm"
if [ ! -f "$home/.tmux/tpm/tpm" ]; then
  echo "Tpm does not exists. Cloning repository"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "-- Installing starship zsh theme\n"
curl -sS https://starship.rs/install.sh | sh -s -- -f

base_path=$( realpath "$0"  )
base_path=$( dirname "$base_path" )

echo "-- Linking config files\n"

echo "---- Neovim: $base_path/nvim -> $home/.config\n"
ln -s "$base_path"/nvim "$home"/.config

mkdir "$home"/.local/scripts
chmod +x "$base_path"/tmux/tmux-sessionizer
echo "---- Tmux sessionizer: $base_path/tmux/tmux-sessionizer -> $home/.local/scripts\n"
ln -s "$base_path"/tmux/tmux-sessionizer "$home"/.local/scripts

echo "---- Tmux config: $base_path/tmux/.tmux.conf -> $home\n"
ln -s "$base_path"/tmux/.tmux.conf "$home"

mkdir ~/.cache/zsh
echo "---- ZSH: $base_path/zsh/.zshrc -> $home\n"
ln -s "$base_path"/zsh/.zshrc "$home"
