# load my zsh configs
source ~/.zsh/load.sh

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

export GOPATH=$HOME/Projects/go

export PATH=$HOME/bin:$GOPATH/bin:$PATH
export PATH=/home/mike/.gem/ruby/2.3.0/bin:$PATH
export PATH=/opt/android-studio/bin:/home/mike/.cargo/bin:$PATH

# source zsh-syntax-highlighting last
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
