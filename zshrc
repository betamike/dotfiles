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
%F{red}${GITHUB_USER:-%n@%m}%F{red} %F{green}%/%F{yellow}${vcs_info_msg_0_}%f
> '
RPROMPT=''

if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
    eval `keychain --eval --agents ssh id_ed25519`
fi

export EDITOR=nvim

alias ls='ls -G --color'
alias ll='ls -l'
alias la='ls -a'

bindkey '^R' history-incremental-search-backward

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH # user custom bins

# source zsh-syntax-highlighting last
source $ZSH/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

if [ -n "${commands[direnv]}" ]; then
    eval "$(direnv hook zsh)"
fi

source "$HOME/.zsh/lscolors.sh"

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
elif [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
