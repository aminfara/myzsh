[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

ssh() {
    command ssh "$@"
    RESULT=$?
    [ -f "$HOME/.base16_theme" ] && source "$HOME/.base16_theme"
    return RESULT
}

if [ ! -f ~/.antigen/antigen.zsh ]
then
  git clone https://github.com/zsh-users/antigen.git .antigen
fi

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle ruby
antigen bundle gem
antigen bundle python
antigen bundle pip
antigen bundle vi-mode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle spwhitt/nix-zsh-completions

antigen theme dst

antigen apply

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

BASE16_SHELL=$HOME/.config/base16-shell
if [ ! -d $BASE16_SHELL ]
then
  git clone https://github.com/chriskempson/base16-shell.git $BASE16_SHELL
fi
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
[ ! -f "$HOME/.base16_theme" ] && base16_solarized-dark

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -x "$(command -v rbenv)" ]  && eval "$(rbenv init -)"
[ -d "$HOME/.pyenv/bin" ] && export PATH="$HOME/.pyenv/bin:$PATH"
[ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

date
