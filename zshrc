case $(uname -s) in
  Linux*)     MACHINE_TYPE=Linux;;
  Darwin*)    MACHINE_TYPE=Mac;;
  *)          MACHINE_TPPE=Unknown
esac

if [ $MACHINE_TYPE = "Unknown" ]
then
  echo "Machine type '$MACHINE_TYPE' is not supported."
  return
fi

# CONFIGURATIONS
################################################################################

ANTIGEN_DIRECTORY=$HOME/.antigen
BASE16_SHELL_DIRECTORY=$HOME/.config/base16-shell
FZF_DIRECTORY=$HOME/.fzf
NVM_DIRECTORY=$HOME/.nvm
PYENV_DIRECTORY=$HOME/.pyenv
RBENV_DIRECTORY=$HOME/.rbenv

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

# HELPERs
################################################################################
print_line() {
  echo
  echo $1
  echo "--------------------------------------------------------------------------------"
}

brew_install_or_upgrade() {
  if [ $(brew ls $1 &>/dev/null) ]
  then
    HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
  else
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
  fi
}

# ANTIGEN
################################################################################

install_antigen() {
  print_line "Installing Antigen"
  if [ ! -f $ANTIGEN_DIRECTORY/antigen.zsh ]
  then
    git clone https://github.com/zsh-users/antigen.git $ANTIGEN_DIRECTORY
  else
    pushd $ANTIGEN_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

uninstall_antigen() {
  rm -rf $ANTIGEN_DIRECTORY &>/dev/null
}

antigen_load_plugins() {
  if [ -f $ANTIGEN_DIRECTORY/antigen.zsh ]
  then
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
    antigen theme dst
    antigen apply
  fi
}

# BASE16_SHELL
################################################################################
install_base16_shell() {
  print_line "Installing Base16 Shell"
  if [ ! -d $BASE16_SHELL_DIRECTORY ]
  then
    git clone https://github.com/chriskempson/base16-shell.git $BASE16_SHELL_DIRECTORY
  else
    pushd $BASE16_SHELL_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

uninstall_base16_shell() {
  rm ~/.vimrc_background &>/dev/null
  rm ~/.base16_theme &>/dev/null
  rm -rf $BASE16_SHELL_DIRECTORY &>/dev/null
}

activate_base16_shell() {
  if [ -d $BASE16_SHELL_DIRECTORY ]
  then
    [ -n $PS1 ] && [ -s $BASE16_SHELL_DIRECTORY/profile_helper.sh ] && eval "$($BASE16_SHELL_DIRECTORY/profile_helper.sh)"
    [ ! -f $HOME/.base16_theme ] && eval "base16_solarized-dark"
  fi
}

# FZF
################################################################################
install_fzf() {
  print_line "Installing FZF"
  if [ ! -d $FZF_DIRECTORY ]
  then
    git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_DIRECTORY
  else
    pushd $FZF_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
  $FZF_DIRECTORY/install --key-bindings --completion --no-update-rc --no-bash --no-fish --64
}

uninstall_fzf(){
  rm -rf $FZF_DIRECTORY &>/dev/null
  rm -rf ~/.fzf* &>/dev/null
  rm -rf ~/.config/fish/functions/fzf_key_bindings.fish &>/dev/null
}

activate_fzf() {
  [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
}

# NVM
################################################################################
install_nvm() {
  print_line "Installing NVM"
  mkdir -p $NVM_DIRECTORY
  if [ $MACHINE_TYPE = Mac ]
  then
    brew_install_or_upgrade nvm
  else
    if [ ! -d $NVM_DIRECTORY/.git ]
    then
      git clone https://github.com/creationix/nvm.git $NVM_DIRECTORY
    else
      pushd $NVM_DIRECTORY &>/dev/null
      git pull
      popd &>/dev/null
    fi
  fi
  activate_nvm
}

uninstall_nvm(){
  if [ $MACHINE_TYPE = Mac ]
  then
    brew uninstall --force nvm
  fi
  rm -rf $NVM_DIRECTORY &>/dev/null
}

activate_nvm() {
  export NVM_DIR=$NVM_DIRECTORY
  [ -s $NVM_DIRECTORY/nvm.sh ] && source $NVM_DIRECTORY/nvm.sh
  [ $(command -v brew) ] && [ -s $(brew --prefix)/opt/nvm/nvm.sh ] && source $(brew --prefix)/opt/nvm/nvm.sh
  true
}

# PYENV
################################################################################
install_pyenv() {
  print_line "Installing pyenv"
  mkdir -p $PYENV_DIRECTORY
  if [ $MACHINE_TYPE = Mac ]
  then
    brew_install_or_upgrade pyenv
  else
    if [ ! -d $PYENV_DIRECTORY/.git ]
    then
      git clone https://github.com/pyenv/pyenv.git $PYENV_DIRECTORY
    else
      pushd $PYENV_DIRECTORY &>/dev/null
      git pull
      popd &>/dev/null
    fi
  fi
  activate_pyenv
}

uninstall_pyenv() {
  if [ $MACHINE_TYPE = Mac ]
  then
    brew uninstall --force pyenv
  fi
  rm -rf $PYENV_DIRECTORY &>/dev/null
}

activate_pyenv() {
  [ -d $PYENV_DIRECTORY/bin ] && export PATH=$PYENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"
  true
}

# RBENV
################################################################################
install_rbenv() {
  print_line "Installing rbenv"
  mkdir -p $RBENV_DIRECTORY
  if [ $MACHINE_TYPE = Mac ]
  then
    brew_install_or_upgrade rbenv
  else
    if [ ! -d $RBENV_DIRECTORY/.git ]
    then
      git clone https://github.com/rbenv/rbenv.git $RBENV_DIRECTORY
      mkdir -p $RBENV_DIRECTORY/plugins
      git clone https://github.com/rbenv/ruby-build.git $RBENV_DIRECTORY/plugins/ruby-build
    else
      pushd $RBENV_DIRECTORY &>/dev/null
      git pull
      popd &>/dev/null
      pushd $RBENV_DIRECTORY/plugins/ruby-build &>/dev/null
      git pull
      popd &>/dev/null
    fi
  fi
  activate_rbenv
}

uninstall_rbenv() {
  if [ $MACHINE_TYPE = Mac ]
  then
    brew uninstall --force rbenv
  fi
  rm -rf $RBENV_DIRECTORY &>/dev/null
}

activate_rbenv() {
  [ -d $RBENV_DIRECTORY/bin ] && export PATH=$RBENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v rbenv)" ] && eval "$(rbenv init -)"
  true
}

# ALL INSTALLERS
################################################################################

install_all() {
  install_antigen
  install_base16_shell
  install_fzf
  install_nvm
  install_pyenv
  install_rbenv
}

uninstall_all() {
  uninstall_antigen
  uninstall_base16_shell
  uninstall_fzf
  uninstall_nvm
  uninstall_pyenv
  uninstall_rbenv
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

# The following line cannot be sourced inside a function!
[ -f $ANTIGEN_DIRECTORY/antigen.zsh ] && source $ANTIGEN_DIRECTORY/antigen.zsh

antigen_load_plugins

bind_arrow_keys_history

activate_base16_shell
activate_fzf
activate_nvm
activate_pyenv
activate_rbenv

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

date
