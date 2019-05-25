# Setup fzf
# ---------
if [[ ! "$PATH" == */home/endo/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/endo/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/endo/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/endo/.fzf/shell/key-bindings.bash"

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

