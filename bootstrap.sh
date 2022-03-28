#!/bin/bash

# NOTE: this is really only for Codespaces dotfiles integration right now.
# Needs work to be more generally useful

local_bin="$HOME/.local/bin"
mkdir -p "$local_bin"
user_config="$HOME/.config"
mkdir -p "$user_config"

# codespaces specific setup
# goes first so it can install things potentially needed later
if [[ "$CODESPACES" == "true" ]]; then
    echo "Detected Codespaces"

    # AppImages require fuse
    apt update
    apt install libfuse2

    # install neovim AppImage
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    chmod u+x nvim.appimage
    mv nvim.appimage "$local_bin"
    rm "$local_bin/nvim"
    # make nvim alias
    ln -s "$local_bin/nvim.appimage" "$local_bin/nvim"

    # set ZSH as the default shell
    chsh -s /bin/zsh

    # install RipGrep
    rg_archive_name="ripgrep-13.0.0-x86_64-unknown-linux-musl"
    rg_sha256sum="ee4e0751ab108b6da4f47c52da187d5177dc371f0f512a7caaec5434e711c091"
    curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/$rg_archive_name.tar.gz"
    echo "$rg_sha256sum $rg_archive_name.tar.gz" | sha256sum --check --status
    if [[ "$?" -ne 0 ]]; then
        echo "RipGrep archive checksum failed! Bailing."
        exit 1
    fi
    tar xzf "$rg_archive_name.tar.gz"
    mv "$rg_archive_name/rg" "$local_bin/rg"
fi

# init submodules for zsh syntax highlight plugin
git submodule update --init

# symlink zsh files
rm "$HOME/.zshrc"
ln -s "$PWD/zshrc" "$HOME/.zshrc"
rm "$HOME/.zsh"
ln -s "$PWD/zsh" "$HOME/.zsh"

# setup neovim config directory
rm -r "$user_config/nvim"
ln -s "$PWD/nvim" "$HOME/.config/nvim"

nvim_autoload_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
mkdir -p "$nvim_autoload_dir"
rm "$nvim_autoload_dir/plug.vim"
ln -s "$PWD/vim-plug.vim" "$nvim_autoload_dir/plug.vim"

if [ -n "${commands[nvim]}" ]; then
    nvim +PlugInstall +qall
    # the sleep is needed because +COQdeps is async
    nvim +COQdeps +30sleep +qall
elif [ -f "$local_bin/nvim" ]; then
    "$local_bin/nvim" +PlugInstall +qall
    # the sleep is needed because +COQdeps is async
    "$local_bin/nvim" +COQdeps +30sleep +qall
fi

kernel=$(uname -s)
# check if we should do linux specific setup
if [[ "$kernel" == "Linux" ]]; then
    echo "detected Linux"
    mkdir -p "$user_config/i3"
    rm "$user_config/i3/config"
    ln -s "$PWD/i3/config" "$user_config/i3/config"
fi

# check if we should do macos specific setup
if [[ "$kernel" == "Darwin" ]]; then
    echo "detected macOS"
    mkdir -p "$HOME/.nixpkgs"
    rm "$HOME/.nixpkgs/darwin-configuration.nix"
    ln -s "$PWD/nix-darwin/darwin-configuration.nix" "$HOME/.nixpkgs/darwin-configuration.nix"
fi
