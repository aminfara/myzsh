#!/bin/bash

# Check machine type
case $(uname -s) in
Linux*) MACHINE_TYPE=Linux ;;
Darwin*)
  if [ "$(uname -m)" = "arm64" ]; then
    MACHINE_TYPE=Mac_aarch
  else
    MACHINE_TYPE=Mac_x86
  fi
  ;;
*) MACHINE_TYPE=Unknown ;;
esac

# If the MACHINE_TYPE is Unknown exit
if [ $MACHINE_TYPE = "Unknown" ]; then
  echo "Machine type '$MACHINE_TYPE' is not supported."
  exit 1
fi

# CONFIGURATIONS
################################################################################

export MYZSH_INSTALLED_DIR=$HOME/.myzsh
export LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew
export HOMEBREW_DIRECTORY_ARCH=/opt/homebrew
export HOMEBREW_DIRECTORY_X86=/usr/local/Homebrew
export RTX_PREFIX="$HOME/.local/share/rtx"
export N_PREFIX="$HOME/.n"
export NPM_DIRECTORY=$HOME/.npm
export ANTIGEN_DIRECTORY=$HOME/.antigen
export DOCKER_DIRECTORY="$HOME/.docker"

export SPACESHIP_GIT_SYMBOL="⎇  "
export SPACESHIP_DIR_TRUNC=0
export SPACESHIP_DIR_TRUNC_REPO=false
export SPACESHIP_TIME_SHOW=true
export SPACESHIP_PROMPT_ORDER=(time user dir host git node venv exec_time line_sep battery jobs exit_code char)

# SET PARAMETERS
################################################################################

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

# HELPERS
################################################################################

print_line() {
  echo
  echo "$@"
  echo "--------------------------------------------------------------------------------"
}

[ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -d $HOMEBREW_DIRECTORY_ARCH/bin ] && eval "$($HOMEBREW_DIRECTORY_ARCH/bin/brew shellenv)"
[ -d $HOMEBREW_DIRECTORY_X86/bin ] && eval "$($HOMEBREW_DIRECTORY_X86/bin/brew shellenv)"
true

is_homebrew_installed() {
  if [ ! -v BREW_INSTALLED ]
  then
    type brew &>/dev/null
    export BREW_INSTALLED="$?"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
  return $BREW_INSTALLED
}

brew_install_or_upgrade() {
  install_homebrew
  brew ls "$@" &>/dev/null
  if [ "$?" -eq "0" ]
  then
    print_line "Brew upgrading " "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$@"
  else
    print_line "Brew installing r" "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$@"
  fi
}

brew_uninstall() {
  if is_homebrew_installed
  then
    print_line "Brew uninstalling " "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall "$@"
  else
    echo "Homebrew is not installed"
    return 1
  fi
}

git_install_or_update() {
  if [ ! -d "$1"/.git ]
  then
    print_line "Installing $2"
    git clone https://github.com/"$2" "$1"
  else
    print_line "Updating $2"
    pushd "$1" &>/dev/null
    git pull
    popd &>/dev/null
  fi
}

# Install Homebrew
################################################################################

install_linux_build_essentials() {
  print_line "Installing Linux build essentials"
  if command -v "yum" &> /dev/null
  then
    # AL2
    sudo yum -y groups install "buildsys-build"
    sudo yum -y groups install "Development Tools"
    # python-build https://github.com/pyenv/pyenv/wiki#suggested-build-environment (Fedora)
    sudo yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl11-devel xz xz-devel libffi-devel findutils
    # Homebrew on Linux https://docs.brew.sh/Homebrew-on-Linux
    sudo yum -y install procps-ng curl file git
  fi

  if command -v "apt" &> /dev/null
  then
    # Ubuntu
    sudo apt update
    # Homebrew on Linux https://docs.brew.sh/Homebrew-on-Linux
    sudo apt install build-essential procps curl file git python3-pip vim
    # python-build https://github.com/pyenv/pyenv/wiki#suggested-build-environment (Ubuntu)
    sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  fi
}

install_homebrew() {
  if ! is_homebrew_installed
  then
    if [ "$MACHINE_TYPE" = Linux ]
    then
      install_linux_build_essentials
    fi

    print_line "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    activate_homebrew
    unset BREW_INSTALLED
  fi
}

# CLI goodies
################################################################################

myzsh_install_cli_tools() {
  brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk
  brew_install_or_upgrade git wget fd ripgrep fzf htop jq gnupg tree tmux lazygit shellcheck shfmt bottom
  brew_install_or_upgrade -f gdu
  brew link --overwrite gdu  # if you have coreutils installed as well
  # Install fzf key bindings
  $(brew --prefix fzf)/install --key-bindings --completion --no-update-rc --no-bash --no-fish
  [ -f $HOME/.tmux.conf ] || ln -s $MYZSH_INSTALLED_DIR/tmux.conf $HOME/.tmux.conf
  cp $MYZSH_INSTALLED_DIR/gitconfig-template $HOME/.gitconfig
  myzsh_activate_cli_tools
}

myzsh_uninstall_cli_tools() {
  brew_uninstall gdu git wget fd ripgrep fzf htop jq gnupg tree tmux lazygit shellcheck shfmt bottom
  brew_uninstall openssl readline sqlite3 xz zlib tcl-tk
  brew unlink gdu
  [ -f $HOME/.fzf.zsh ] && rm $HOME/.fzf.zsh || true
}

myzsh_activate_cli_tools () {
  if [ -f $HOME/.fzf.zsh ]
  then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    bindkey "ç" fzf-cd-widget
    source $HOME/.fzf.zsh
  fi
}

# ANTIGEN
################################################################################

myzsh_install_antigen() {
  brew_install_or_upgrade antigen
  myzsh_activate_antigen
}

myzsh_uninstall_antigen() {
  brew_uninstall antigen
  rm -rf $ANTIGEN_DIRECTORY &>/dev/null
}

myzsh_activate_antigen() {
  type antigen &>/dev/null && return

  if is_homebrew_installed
  then
    ANTIGEN_EXEC_DIRECTORY=$(brew --prefix antigen)/share/antigen
    if [ -f $ANTIGEN_EXEC_DIRECTORY/antigen.zsh ]
    then
      source $ANTIGEN_EXEC_DIRECTORY/antigen.zsh
      antigen use oh-my-zsh
      antigen bundle vi-mode
      antigen bundle key-bindings
      if [ $MACHINE_TYPE = "Mac" ]
      then
        antigen bundle macos
      fi
      antigen bundle git
      antigen bundle zsh-users/zsh-autosuggestions
      antigen bundle zsh-users/zsh-syntax-highlighting
      antigen bundle zsh-users/zsh-history-substring-search
      antigen theme spaceship-prompt/spaceship-prompt
      antigen apply
    fi
  fi
}

# RTX
################################################################################

myzsh_install_rtx() {
  brew_install_or_upgrade rtx
  rtx_activation_file="$(brew --prefix rtx)/bin/rtx"
  eval "$($rtx_activation_file install)"
  myzsh_activate_rtx
}

myzsh_uninstall_rtx() {
  brew_uninstall rtx
  rm -rf "$RTX_PREFIX"
}

myzsh_activate_rtx() {
  if is_homebrew_installed
  then
    rtx_activation_file="$(brew --prefix rtx)/bin/rtx"
    [ -f "$rtx_activation_file" ] && eval "$($rtx_activation_file activate zsh)"
  fi
  true
}

# Python
################################################################################

myzsh_install_python() {
  # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk pyenv
  print_line "Installing python $1"
  pyenv install $1
  pyenv global $1
  activate_pyenv
  python3 -m pip install --upgrade pip
  echo "Python version:"
  python --version
}

myzsh_activate_python() {
  command -v pyenv >/dev/null && eval "$(pyenv init -)"
  true
}

# Node
################################################################################

myzsh_install_node() {
  brew_install_or_upgrade n
  print_line "Installing NodeJS $1"
  n $1
  myzsh_activate_node
  echo "NodeJS version:"
  node --version
}

myzsh_activate_node() {
  [ -d $N_PREFIX/bin ] && export PATH="$N_PREFIX/bin:$PATH"
  true
}

# Rust
################################################################################

myzsh_activate_rust() {
  [ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"
  true
}

# Java
################################################################################

myzsh_install_java() {
  install_homebrew
  brew tap homebrew/cask-versions
  brew_install_or_upgrade --cask temurin17
  echo "Java version:"
  java -version
}

myzsh_activate_java() {
  /usr/libexec/java_home &>/dev/null
  JAVA_EXISTS=$?
  if [ $JAVA_EXISTS -eq 0 ]; then
    JAVA_HOME=$(/usr/libexec/java_home)
    export JAVA_HOME
    export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
  fi
  true
}

# Docker
################################################################################

activate_docker() {
  [ -f "$DOCKER_DIRECTORY/init-zsh.sh" ] && (source "$DOCKER_DIRECTORY/init-zsh.sh" || true)
}

# Neovim
################################################################################
myzsh_install_neovim() {
  brew_install_or_upgrade homebrew/cask-fonts/font-meslo-lg-nerd-font
  brew_install_or_upgrade neovim stylua
  npm install -g neovim tree-sitter-cli
  python3 -m pip install pynvim
}

myzsh_uninstall_neovim() {
  brew_uninstall neovim stylua
  npm uninstall -g neovim tree-sitter-cli
  python3 -m pip uninstall -y pynvim
  rm -rf $MYZSH_INSTALLED_DIR/nvim/plugin/packer_compiled.lua
  rm -rf $HOME/.config/nvim
  rm -rf $HOME/.local/share/nvim
  rm -rf $HOME/.cache/nvim
}

# Mac key repeat for vscode
################################################################################

fix_key_repeat_for_vscode() {
  if [ $MACHINE_TYPE = Linux ]
  then
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  fi
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
  if typeset -f history-substring-search-up > /dev/null
  then
      bindkey "${key[Up]}" history-substring-search-up
      bindkey -M vicmd "${key[Up]}" history-substring-search-up
      bindkey -M vicmd "k"       history-substring-search-up
      bindkey "${key[Down]}" history-substring-search-down
      bindkey -M vicmd "${key[Down]}" history-substring-search-down
      bindkey -M vicmd "j"       history-substring-search-down
  fi
}

# Auto completion
################################################################################

myzsh_update_auto_completions() {
  # We do not need compinit as oh-my-zsh will run compinit
  if is_homebrew_installed
  then
    if [ $MACHINE_TYPE = Linux ]
    then
      FPATH="$LINUXBREW_DIRECTORY/share/zsh/site-functions:${FPATH}"
    fi
  fi
}

# Turn off beep
setopt nobeep

myzsh_update_auto_completions # should be before antigen
myzsh_activate_cli_tools
myzsh_activate_antigen
myzsh_activate_rtx
# myzsh_activate_python
# myzsh_activate_node
myzsh_activate_rust
# activate_java
activate_docker

myzsh_keybindings

[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH=$HOME/.local/bin:$PATH

date
