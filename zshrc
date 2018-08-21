# CONFIGURATIONS
################################################################################

ANTIGEN_DIRECTORY=$HOME/.antigen
BASE16_SHELL_DIRECTORY=$HOME/.config/base16-shell
FZF_DIRECTORY=$HOME/.fzf
NIX_PROFILE_DIRECTORY=$HOME/.nix-profile/etc/profile.d
NVM_DIRECTORY=$HOME/.nvm
PYENV_DIRECTORY=$HOME/.pyenv
RBENV_DIRECTORY=$HOME/.rbenv

# HELPERs
################################################################################
print_line() {
  echo
  echo $1
  echo "--------------------------------------------------------------------------------"
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
  [ -n $PS1 ] && [ -s $BASE16_SHELL_DIRECTORY/profile_helper.sh ] && eval "$($BASE16_SHELL_DIRECTORY/profile_helper.sh)"
  [ ! -f $HOME/.base16_theme ] && eval "base16_solarized-dark"
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
  $FZF_DIRECTORY/install --key-bindings --completion --no-update-rc
}

uninstall_fzf(){
  rm -rf $FZF_DIRECTORY &>/dev/null
  rm -rf ~/.fzf* &>/dev/null
  rm -rf ~/.config/fish/functions/fzf_key_bindings.fish &>/dev/null
}

activate_fzf() {
  [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
}

# NIX
################################################################################
install_nix() {
  print_line "Installing NIX"
  if [ ! -d /nix ]
  then
    sudo mkdir -m 0755 /nix && sudo chown $USER /nix
    curl https://nixos.org/nix/install | sh
  fi
}

uninstall_nix() {
  sudo rm -rf /nix &>/dev/null
  rm -rf $NIX_PROFILE_DIRECTORY &>/dev/null
  # rm -rf ~/.nix* &>/dev/null
}

activate_nix() {
  [ -f $NIX_PROFILE_DIRECTORY/nix.sh ] && source $NIX_PROFILE_DIRECTORY/nix.sh
}

# NVM
################################################################################
install_nvm() {
  print_line "Installing NVM"
  if [ ! -d $NVM_DIRECTORY ]
  then
    git clone https://github.com/creationix/nvm.git $NVM_DIRECTORY
  else
    pushd $NVM_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

uninstall_nvm(){
  rm -rf $NVM_DIRECTORY &>/dev/null
}

activate_nvm() {
  [ -s $NVM_DIRECTORY/nvm.sh ] && source $NVM_DIRECTORY/nvm.sh
  # [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"
}

# PYENV
################################################################################
install_pyenv() {
  print_line "Installing pyenv"
  if [ ! -d $PYENV_DIRECTORY ]
  then
    git clone https://github.com/pyenv/pyenv.git $PYENV_DIRECTORY
  else
    pushd $PYENV_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

uninstall_pyenv() {
  rm -rf $PYENV_DIRECTORY &>/dev/null
}

activate_pyenv() {
  [ -d $PYENV_DIRECTORY/bin ] && export PATH=$PYENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"
}

# RBENV
################################################################################
install_rbenv() {
  print_line "Installing rbenv"
  if [ ! -d $RBENV_DIRECTORY ]
  then
    git clone https://github.com/rbenv/rbenv.git $RBENV_DIRECTORY
    mkdir -p $RBENV_DIRECTORY/plugins
    git clone https://github.com/rbenv/ruby-build.git $RBENV_DIRECTORY/plugins/ruby-build
  else
    pushd $RBENV_DIRECTORY &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

uninstall_rbenv() {
  rm -rf $RBENV_DIRECTORY &>/dev/null
}

activate_rbenv() {
  [ -d $RBENV_DIRECTORY/bin ] && export PATH=$RBENV_DIRECTORY/bin:$PATH
  [ -x "$(command -v rbenv)" ] && eval "$(rbenv init -)"
}

# ALL INSTALLERS
################################################################################

install_all() {
  install_antigen
  install_base16_shell
  install_fzf
  install_nix
  install_nvm
  install_pyenv
  install_rbenv
  touch ~/.myzsh_installed
}

uninstall_all() {
  uninstall_antigen
  uninstall_base16_shell
  uninstall_fzf
  uninstall_nix
  uninstall_nvm
  uninstall_pyenv
  uninstall_rbenv
  rm ~/.myzsh_installed
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

[ ! -f ~/.myzsh_installed ] && install_all

# The following line cannot be sourced inside a function!
source $ANTIGEN_DIRECTORY/antigen.zsh

antigen_load_plugins

bind_arrow_keys_history

activate_base16_shell
activate_fzf
activate_nix
activate_nvm
activate_pyenv
activate_rbenv

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

date
