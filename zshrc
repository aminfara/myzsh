source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle ruby
antigen bundle gem
antigen bundle python
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme dst

antigen apply

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -x "$(command -v rbenv)" ]  && eval "$(rbenv init -)"
[ -d "$HOME/.pyenv/bin" ] && export PATH="$HOME/.pyenv/bin:$PATH"
[ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"

[ -x "$HOME/.vocab" ] && $HOME/.vocab

date
