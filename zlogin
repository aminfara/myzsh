export PATH="/apollo/env/SDETools/bin:$PATH"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
