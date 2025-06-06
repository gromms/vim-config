# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "${XDG_CACHE_HOME:-$HOME/.cache}/.zshrc"

autoload -Uz compaudit compinit promptinit
compaudit
compinit
promptinit

# End of lines added by compinstall

typeset -U path PATH
path=(~/.local/bin $path)
export PATH

zstyle ':completion:*' menu select

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word


autoload -Uz add-zsh-hook

# Determine a unique dirstack file name based on tmux session or default
if [[ -n "$TMUX" ]]; then
  # Extract tmux session name
  TMUX_SESSION_ID=$(tmux display-message -p '#S' 2>/dev/null)
  DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs-${TMUX_SESSION_ID}"
else
  DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
fi

if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

alias ls="ls --color=auto"
alias grep="grep --color=auto"

# Start ssh-agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi

eval "$(starship init zsh)"

echo "$PWD"
