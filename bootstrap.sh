#!/bin/bash

# NOTE: this is really only for Codespaces dotfiles integration right now.
# Needs work to be more generally useful

local_bin="$HOME/.local/bin"
mkdir -p "$local_bin"
user_config="$HOME/.config"
mkdir -p "$user_config"

# init submodules for zsh syntax highlight plugin
git submodule update --init

# symlink zsh files
rm "$HOME/.zshrc"
ln -s "$PWD/zshrc" "$HOME/.zshrc"
rm "$HOME/.zsh"
ln -s "$PWD/zsh" "$HOME/.zsh"

# symlink tmux.conf
rm "$HOME/.tmux.conf"
ln -s "$PWD/tmux.conf" "$HOME/.tmux.conf"

# codespaces specific setup
# goes first so it can install things potentially needed later
if [[ "$CODESPACES" == "true" || "$REMOTE_CONTAINERS" == "true" ]]; then
    echo "Detected Codespaces/Remote Container"

    # needed because github codespaces does some weird environment
    # saving/loading that overrides PATH in /etc/zsh/zlogin
    rm "$HOME/.zlogin"
    ln -s "$PWD/zlogin" "$HOME/.zlogin"

    # set default shell for user
    sudo chsh -s /bin/zsh codespace

    # AppImages require fuse
    sudo apt-get update
    sudo apt-get install -y libfuse2 tmux

    # install neovim AppImage
    nvim_version="v0.8.3"
    nvim_sha256sum="0828910da0b532e7564b1d200645bd846e6b2e1d10aa3111e36b59c1521b16f0"
    nvim_deb_name="nvim-linux64.deb"
    curl -LO "https://github.com/neovim/neovim/releases/download/${nvim_version}/${nvim_deb_name}"
    echo "${nvim_sha256sum} ${nvim_deb_name}" | sha256sum --check --status
    sudo dpkg -i "${nvim_deb_name}"

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

    # install fzf
    fzf_version="0.30.0"
    fzf_archive_name="fzf-${fzf_version}"
    fzf_sha256sum="a3428f510b7136e39104a002f19b2e563090496cb5205fa2e4c5967d34a20124"
    curl -L -o "${fzf_archive_name}.tar.gz" "https://github.com/junegunn/fzf/archive/refs/tags/${fzf_version}.tar.gz"
    echo "${fzf_sha256sum} ${fzf_archive_name}.tar.gz" | sha256sum --check --status
    if [[ "$?" -ne 0 ]]; then
        echo "fzf archive checksum failed! Bailing."
        exit 1
    fi
    tar xzf "${fzf_archive_name}.tar.gz"
    "${fzf_archive_name}/install" --all
fi

# setup neovim config directory
rm -r "$user_config/nvim"
ln -s "$PWD/nvim" "$HOME/.config/nvim"

nvim_autoload_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
mkdir -p "$nvim_autoload_dir"
rm "$nvim_autoload_dir/plug.vim"
ln -s "$PWD/vim-plug.vim" "$nvim_autoload_dir/plug.vim"

nvim_path="nvim"
if [ -f "$local_bin/nvim" ]; then
    echo "found local bin nvim"
    nvim_path="$local_bin/nvim"
fi

# install plugins
$nvim_path -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"
$nvim_path -es -u ~/.config/nvim/init.vim -i NONE -c "LspInstall --sync" -c "qa"

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
