alias ".."="cd .."
alias "..."="cd ../.."
alias ls="ls -G"
alias ll="ls -lah"
alias git=hub
alias develop="cd ~/projects/"

# Load in the git branch prompt script.
source ~/.git-prompt.sh

# Terminal prompt
# Default: \h:\W \u\$
function cool_dir_prompt () {
  p=${PWD/$HOME/\~}
  p=${p/*projects/+}
  if ((${#p} > 30)); then
    echo "${p::5}...${p:(-20)}"
  else
    echo ${p}
  fi
}
## Tab title
PS1="\e]1;\W\a"
## Prompt
PS1="$PS1\[\033[36m\]\u \[\033[33;1m\]\$(cool_dir_prompt)\[\033[1;35m\]\$(__git_ps1)\[\033[m\]❕  "

# Git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Grunt completion
eval "$(grunt --completion=bash)"
# Gulp completion
eval "$(gulp --completion=bash)"

source $( echo $(which vv)-completions)

PATH=$PATH:~/.ellipsis/bin

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
