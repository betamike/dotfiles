# ls colors
autoload -U colors && colors

# default LSCOLORS
export LSCOLORS="Gxfxcxdxbxegedabagacad"

if [[ -f $HOME/.dircolors ]]; then
    eval $(dircolors -b $HOME/.dircolors)
elif [[ -z "$LS_COLORS" ]]; then
  (( $+commands[dircolors] )) && eval "$(dircolors -b)"
fi

# Take advantage of $LS_COLORS for completion as well.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

setopt auto_cd
setopt multios
setopt prompt_subst

[[ -n "$WINDOW" ]] && SCREEN_NO="%B$WINDOW%b " || SCREEN_NO=""
