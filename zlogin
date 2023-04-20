# needed until github fixes a bug with how PATH is loaded
# in codespaces
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
elif [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi
