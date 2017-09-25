ANTIGEN_DIRECTORY=$HOME/.antigen
BASE16_SHELL_DIRECTORY=$HOME/.config/base16-shell
FZF_DIRECTORY=$HOME/.fzf
NIX_PROFILE_DIRECTORY=$HOME/.nix-profile/etc/profile.d
PYENV_DIRECTORY=$HOME/.pyenv
RBENV_DIRECTORY=$HOME/.rbenv
NVM_DIRECTORY=$HOME/.nvm

install_antigen() {
  if [ ! -f $ANTIGEN_DIRECTORY/antigen.zsh ]
  then
    git clone https://github.com/zsh-users/antigen.git $ANTIGEN_DIRECTORY
  fi
}

antigen_load_plugins() {
  antigen use oh-my-zsh
  antigen bundle git
  antigen bundle ruby
  antigen bundle gem
  antigen bundle python
  antigen bundle pip
  antigen bundle nvm
  antigen bundle vi-mode
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle spwhitt/nix-zsh-completions
  antigen theme dst
  antigen apply
}

activate_base16_shell() {
  if [ ! -d $BASE16_SHELL_DIRECTORY ]
  then
    git clone https://github.com/chriskempson/base16-shell.git $BASE16_SHELL_DIRECTORY
  fi

  [ -n $PS1 ] && [ -s $BASE16_SHELL_DIRECTORY/profile_helper.sh ] && eval "$($BASE16_SHELL_DIRECTORY/profile_helper.sh)"
  [ ! -f $HOME/.base16_theme ] && base16_solarized-dark
}

activate_fzf() {
  if [ ! -d $FZF_DIRECTORY ]
  then
    git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_DIRECTORY
    $FZF_DIRECTORY/install --key-bindings --completion --no-update-rc
  fi

  [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
}

activate_nix() {
  [ -f $NIX_PROFILE_DIRECTORY/nix.sh ] && source $NIX_PROFILE_DIRECTORY/nix.sh
}

activate_nvm() {
  if [ ! -d $NVM_DIRECTORY ]
  then
    git clone https://github.com/creationix/nvm.git $NVM_DIRECTORY
  fi

  [ -s $NVM_DIRECTORY/nvm.sh ] && source $NVM_DIRECTORY/nvm.sh
}

activate_pyenv() {
  if [ ! -d $PYENV_DIRECTORY ]
  then
    git clone https://github.com/pyenv/pyenv.git $PYENV_DIRECTORY
  fi

  [ -d $PYENV_DIRECTORY/bin ] && export PATH=$PYENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"
}

activate_rbenv() {
  if [ ! -d $RBENV_DIRECTORY ]
  then
    git clone https://github.com/rbenv/rbenv.git $RBENV_DIRECTORY
    mkdir -p $RBENV_DIRECTORY/plugins
    git clone https://github.com/rbenv/ruby-build.git $RBENV_DIRECTORY/plugins/ruby-build
  fi

  [ -d $RBENV_DIRECTORY/bin ] && export PATH=$RBENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v rbenv)" ]  && eval "$(rbenv init -)"
}

ssh() {
    command ssh "$@"
    RESULT=$?
    [ -f $HOME/.base16_theme ] && source $HOME/.base16_theme
    return RESULT
}

bind_arrow_keys_history() {
  # bind UP and DOWN arrow keys
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
}

install_antigen
# The following line cannot be sourced inside a function!
source $ANTIGEN_DIRECTORY/antigen.zsh

antigen_load_plugins
activate_nix
bind_arrow_keys_history
activate_base16_shell
activate_fzf
activate_nvm
activate_pyenv
activate_rbenv

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

date
