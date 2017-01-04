# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
#ZSH_THEME="robbyrussell"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Plugins to load
plugins=(git go osx zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

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

export EDITOR=nvim

alias ls='ls -G --color'
alias ll='ls -l'
alias la='ls -a'

bindkey '^R' history-incremental-search-backward

# setup paths for Go and Goat
export GOAT_ACTUALGO=/usr/local/go/bin/go
export GOPATH=$HOME/Projects/go

# add Go bin and brew's bin to path
export PATH=$GOPATH/bin:$(brew --prefix)/bin:$PATH
