#!/bin/bash

# init submodules for zsh syntax highlight plugin
git submodule update --init

# symlink zsh files
ln -s "$PWD/zshrc" "$HOME/.zshrc"
ln -s "$PWD/zsh" "$HOME/.zsh"

# setup neovim config directory
mkdir -p "$HOME/.config/nvim"
ln -s "$PWD/init.vim" "$HOME/.config/nvim/init.vim"

nvim_autoload_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
mkdir -p "$nvim_autoload_dir"
ln -s "$PWD/vim-plug.vim" "$nvim_autoload_dir/plug.vim"

if [ -n "${commands[nvim]}" ]; then
    eval "$(nvim +PluginInstall +qall)"
fi

kernel=$(uname -s)
# check if we should do linux specific setup
if [[ "$kernel" == "Linux" ]]; then
    echo "detected Linux"
    mkdir -p "$HOME/.config/i3"
    ln -s "$PWD/i3/config" "$HOME/.config/i3/config"
fi

# check if we should do macos specific setup
if [[ "$kernel" == "Darwin" ]]; then
    echo "detected macOS"
    mkdir -p "$HOME/.nixpkgs"
    ln -s "$PWD/nix-darwin/darwin-configuration.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
fi
