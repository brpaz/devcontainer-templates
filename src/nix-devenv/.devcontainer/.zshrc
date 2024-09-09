# ZSH Configuration file.
# This file is loaded by zsh at startup.
# It should be kept as small as possible for better readability.
# You can place your custom configuration in ~/.zshrc.d directory, which is loaded by Antidote plugin.

# clone antidote if necessary
[[ -e ~/.antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.antidote

# =========================================
# ZSH options
# =========================================
setopt auto_cd
setopt auto_pushd

HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed%

# Zstyle settings
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''
fpath=(~/.zsh/completion $fpath) # custom completions

# Setup compinit
autoload -U compinit && compinit

# Antidone configuration
export ANTIDOTE_HOME=~/.local/share/antidote/plugins
. ~/.antidote/antidote.zsh
antidote load



# ==================================
# FZF configuration
# ==================================
alias fd=fdfind

source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="fd --hidden"
export FZF_DEFAULT_OPTS="--exact --reverse --height 60% --ansi --bind='alt-enter:execute(xdg-open {})+abort'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

bindkey '^@' fzf-file-widget

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# ===================================
# Shell prompt
# ===================================
eval "$(starship init zsh)"

# ====================================
# direnv shell hook
# ====================================
eval "$(direnv hook zsh)"

# ====================================
# Nix profile daemon
# ====================================
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Use .zshrc.d for custom configuration.
# Files in this directory are machine specific and should not be checked into dotfiles repo.
if [[ -d $HOME/.zshrc.d.local ]]; then
  for config_file ($HOME/.zshrc.d.local/*.zsh) source $config_file
fi
