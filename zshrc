# load my zsh configs
source ~/.zsh/load.sh
source ~/.nix-profile/etc/profile.d/nix.sh

# turn off mostly unhelpful autocorrect
unsetopt correct_all

# Fix Home and End keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats " ± (%b)"
zstyle ':vcs_info:svn*' formats " %s (%b)"

precmd() {
    vcs_info
}

setopt PROMPT_SUBST

PROMPT='
%F{red}%n@%m%F{red} %F{green}%/%F{yellow}${vcs_info_msg_0_}%f
> '

eval `keychain --eval --agents ssh id_rsa`

export EDITOR=nvim

alias ls='ls -G --color'
alias ll='ls -l'
alias la='ls -a'

bindkey '^R' history-incremental-search-backward

export GOPATH=$HOME/Projects/go
export RUST_SRC_PATH=$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src

export PATH=$HOME/bin:$HOME/.local/bin:$PATH # user custom bins
export PATH=$GOPATH/bin:$PATH # go bin
export PATH=$HOME/.gem/ruby/2.3.0/bin:$PATH  # ruby gem bin
export PATH=$HOME/.cargo/bin:$PATH # rust cargo bin
export PATH=$HOME/Android/Sdk/platform-tools:$PATH # android studio bin
export PATH=$HOME/.poetry/bin:$PATH # android studio bin

# source zsh-syntax-highlighting last
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
