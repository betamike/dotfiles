# path to my zsh configs
ZSH=$HOME/.zsh

# load the things
fpath=($ZSH/functions $ZSH/completions $fpath)
autoload -U compaudit compinit

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/functions/*.zsh); do
  source $config_file
done

compinit -d "${ZSH_COMPDUMP}/cache"
