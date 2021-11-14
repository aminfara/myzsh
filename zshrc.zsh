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
N_DIRECTORY=$HOME/.n
NVM_DIRECTORY=$HOME/.nvm
PYENV_ROOT=$HOME/.pyenv
RBENV_DIRECTORY=$HOME/.rbenv
LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

SPACESHIP_GIT_SYMBOL="⎇  "
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_VI_MODE_INSERT=I
SPACESHIP_VI_MODE_NORMAL=N
SPACESHIP_VI_MODE_COLOR=black
SPACESHIP_TIME_SHOW=true

# HELPERs
################################################################################
print_line() {
  echo
  echo $@
  echo "--------------------------------------------------------------------------------"
}

brew_install_or_upgrade() {
  brew ls "$@" &>/dev/null
  if [ "$?" -eq "0" ]
  then
    print_line "Brew upgrading $@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$@"
  else
    print_line "Brew installing $@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$@"
  fi
}

brew_uninstall() {
  print_line "Brew uninstalling $@"
  HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall "$@"
}

ssh() {
    command ssh "$@"
    RESULT=$?
    [ -f $HOME/.base16_theme ] && source $HOME/.base16_theme
    return RESULT
}

# Auto completion
################################################################################
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

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
    antigen bundle vi-mode
    # antigen bundle key-bindings
    if [ $MACHINE_TYPE = "Mac" ]
    then
      antigen bundle osx
    fi
    antigen bundle git
    antigen bundle python
    antigen bundle pip
    antigen bundle node
    antigen bundle npm
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-history-substring-search
    antigen theme denysdovhan/spaceship-prompt
    antigen apply
  fi
}

# CLI goodies
################################################################################
install_cli_tools() {
  brew_install_or_upgrade fd ripgrep fzf htop
  # Install fzf key bindings
  $(brew --prefix fzf)/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

uninstall_cli_tools() {
  brew_uninstall fd ripgrep fzf
  [ -f $HOME/.fzf.zsh ] && rm $HOME/.fzf.zsh || true
}

activate_cli_tools () {
  if [ -f $HOME/.fzf.zsh ]
  then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    bindkey "ç" fzf-cd-widget
    source $HOME/.fzf.zsh
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

# ASDF
################################################################################
install_asdf() {
  print_line "Installing asdf"
  brew_install_or_upgrade asdf
}

uninstall_asdf() {
  brew_uninstall asdf
}

activate_asdf() {
  ASDF_SHELL=$(brew --prefix asdf)/libexec/asdf.sh
  [ -f "$ASDF_SHELL" ] && source $ASDF_SHELL
}

# N
################################################################################
install_n() {
  print_line "Installing N"
  brew_install_or_upgrade n
  activate_n
}

uninstall_n(){
  brew uninstall --force n
  rm -rf $N_DIRECTORY &>/dev/null
}

activate_n() {
  export N_PREFIX=$N_DIRECTORY
  [ -s $N_DIRECTORY/bin ] && export PATH=$N_DIRECTORY/bin:$PATH
  true
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
  mkdir -p $PYENV_ROOT
  if [ $MACHINE_TYPE = Mac ]
  then
    brew_install_or_upgrade pyenv
  else
    if [ ! -d $PYENV_ROOT/.git ]
    then
      git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
    else
      pushd $PYENV_ROOT &>/dev/null
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
  rm -rf $PYENV_ROOT &>/dev/null
}

activate_pyenv() {
  [ -d $PYENV_ROOT/bin ] && export PATH=$PYENV_ROOT/bin:$PATH
  [ -x "$(command -v pyenv)" ] && eval "$(pyenv init --path)" && eval "$(pyenv init -)"
  true
}

# POETRY
################################################################################
install_poetry() {
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
  activate_poetry
}

uninstall_poetry() {
  curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_UNINSTALL=1 python
}

activate_poetry() {
  [ -d $HOME/.poetry/bin ] && export PATH=$HOME/.poetry/bin:$PATH
  alias po="poetry"
  alias pr="poetry run"
  alias prt="poetry run task"
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

# Linux brew
################################################################################

activate_linuxbrew() {
  [ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  true
}


# KEY BINDINGS
################################################################################

myzsh_keybindings() {
  zmodload zsh/terminfo

  # From https://github.com/robbyrussell/oh-my-zsh/issues/7330

  # create a zkbd compatible hash;
  # to add other keys to this hash, see: man 5 terminfo
  typeset -A key

  key=(
    BackSpace  "${terminfo[kbs]}"
    Home       "${terminfo[khome]}"
    End        "${terminfo[kend]}"
    Insert     "${terminfo[kich1]}"
    Delete     "${terminfo[kdch1]}"
    Up         "${terminfo[kcuu1]}"
    Down       "${terminfo[kcud1]}"
    Left       "${terminfo[kcub1]}"
    Right      "${terminfo[kcuf1]}"
    PageUp     "${terminfo[kpp]}"
    PageDown   "${terminfo[knp]}"
  )

  # setup key accordingly
  [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"      beginning-of-line
  [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"       end-of-line
  [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"    overwrite-mode
  [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"    delete-char
  [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"        up-line-or-history
  [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"      down-line-or-history
  [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"      backward-char
  [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"     forward-char
  [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    beginning-of-buffer-or-history
  [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  end-of-buffer-or-history
  [[ -n "${key[BackSpace]}" ]] && bindkey  "${key[BackSpace]}" backward-delete-char
  [[ -n "${key[Home]}"      ]] && bindkey -M vicmd "${key[Home]}" beginning-of-line
  [[ -n "${key[End]}"       ]] && bindkey -M vicmd "${key[End]}" end-of-line

  # Finally, make sure the terminal is in application mode, when zle is
  # active. Only then are the values from $terminfo valid.
  if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
      function zle-line-init () {
          printf '%s' "${terminfo[smkx]}"
      }
      function zle-line-finish () {
          printf '%s' "${terminfo[rmkx]}"
      }
      zle -N zle-line-init
      zle -N zle-line-finish
  fi


  # From old bindings

  # bind UP and DOWN arrow keys
  if if typeset -f history-substring-search-up > /dev/null
  then
      bindkey "${key[Up]}" history-substring-search-up
      bindkey -M vicmd "${key[Up]}" history-substring-search-up
      bindkey -M vicmd "k"       history-substring-search-up
      bindkey "${key[Down]}" history-substring-search-down
      bindkey -M vicmd "${key[Down]}" history-substring-search-down
      bindkey -M vicmd "j"       history-substring-search-down
  fi
}

# ALL INSTALLERS
################################################################################

install_all() {
  install_antigen
  install_base16_shell
  install_fzf
  install_n
  install_nvm
  install_pyenv
  install_poetry
  install_rbenv
}

uninstall_all() {
  uninstall_antigen
  uninstall_base16_shell
  uninstall_fzf
  uninstall_n
  uninstall_nvm
  uninstall_pyenv
  uninstall_poetry
  uninstall_rbenv
}

# The following line cannot be sourced inside a function!
[ -f $ANTIGEN_DIRECTORY/antigen.zsh ] && source $ANTIGEN_DIRECTORY/antigen.zsh

antigen_load_plugins

# bind_arrow_keys_history

activate_base16_shell
activate_cli_tools
activate_n
activate_nvm
activate_pyenv
activate_poetry
activate_rbenv
activate_linuxbrew
activate_asdf

myzsh_keybindings

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH=$HOME/.local/bin:$PATH
date
