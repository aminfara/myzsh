#!/bin/bash

# Set MACHINE_TYPE
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

# Set HOMEBREW_DIRECTORY based on MACHINE_TYPE
case $MACHINE_TYPE in
Mac_aarch) export HOMEBREW_DIRECTORY=/opt/homebrew ;;
Mac_x86) export HOMEBREW_DIRECTORY=/usr/local/Homebrew ;;
Linux) export HOMEBREW_DIRECTORY=/home/linuxbrew/.linuxbrew ;;
esac

# CONFIGURATIONS
################################################################################

export MYZSH_INSTALLED_DIR=$HOME/.myzsh
export ANTIGEN_DIRECTORY=$HOME/.antigen
export DOCKER_DIRECTORY="$HOME/.docker"
export N_PREFIX="$HOME/.n"
export NPM_DIRECTORY=$HOME/.npm

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

myzsh_install_linux_build_essentials() {
  print_line "Installing Linux build essentials"
  if command -v "yum" &>/dev/null; then
    # AL2
    sudo yum -y groups install "buildsys-build"
    sudo yum -y groups install "Development Tools"
    # python-build https://github.com/pyenv/pyenv/wiki#suggested-build-environment (Fedora)
    sudo yum -y install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl11-devel xz xz-devel libffi-devel findutils
    # Homebrew on Linux https://docs.brew.sh/Homebrew-on-Linux
    sudo yum -y install procps-ng curl file git
  fi

  if command -v "apt" &>/dev/null; then
    # Ubuntu
    sudo apt update
    # Homebrew on Linux https://docs.brew.sh/Homebrew-on-Linux
    sudo apt install build-essential procps curl file git python3-pip vim
    # python-build https://github.com/pyenv/pyenv/wiki#suggested-build-environment (Ubuntu)
    sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  fi
}

# Homebrew
################################################################################

function myzsh_activate_homebrew() {
  if [ -d "$HOMEBREW_DIRECTORY/bin" ]; then
    eval "$("$HOMEBREW_DIRECTORY"/bin/brew shellenv)"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    export HOMEBREW_INSTALLED=0
  fi
}

myzsh_is_homebrew_installed() {
  if [ ! -v HOMEBREW_INSTALLED ]; then
    type brew &>/dev/null
    export HOMEBREW_INSTALLED="$?"
  fi
  return "$HOMEBREW_INSTALLED"
}

myzsh_install_homebrew() {
  if ! myzsh_is_homebrew_installed; then
    if [ "$MACHINE_TYPE" = Linux ]; then
      myzsh_install_linux_build_essentials
    fi
    print_line "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    myzsh_activate_homebrew
    unset HOMEBREW_INSTALLED
  else
    print_line "Homebrew is already installed"
  fi
}

myzsh_brew_install_or_upgrade() {
  myzsh_install_homebrew
  if brew ls "$@" &>/dev/null; then
    print_line "Brew upgrading" "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$@"
  else
    print_line "Brew installing" "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$@"
  fi
}

myzsh_brew_uninstall() {
  if myzsh_is_homebrew_installed; then
    print_line "Brew uninstalling " "$@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall "$@"
  else
    echo "Homebrew is not installed"
    return 1
  fi
}

# CLI goodies
################################################################################

myzsh_install_cli_tools() {
  myzsh_brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk
  myzsh_brew_install_or_upgrade git wget fd ripgrep fzf htop jq tree tmux lazygit shellcheck shfmt bottom
  # Install fzf key bindings
  "$(brew --prefix fzf)/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
  [ -f "$HOME"/.tmux.conf ] || ln -s "$MYZSH_INSTALLED_DIR"/tmux.conf "$HOME"/.tmux.conf
  cp "$MYZSH_INSTALLED_DIR"/gitconfig-template "$HOME"/.gitconfig
  myzsh_activate_cli_tools
}

myzsh_uninstall_cli_tools() {
  myzsh_brew_uninstall git wget fd ripgrep fzf htop jq tree tmux lazygit shellcheck shfmt bottom
  myzsh_brew_uninstall openssl readline sqlite3 xz zlib tcl-tk
  [ -f "$HOME"/.fzf.zsh ] && rm "$HOME"/.fzf.zsh
  true
}

myzsh_activate_cli_tools() {
  if [ -f "$HOME"/.fzf.zsh ]; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    bindkey "ç" fzf-cd-widget
    # shellcheck disable=SC1091
    source "$HOME"/.fzf.zsh
  fi
}

# ANTIGEN
################################################################################

myzsh_install_antigen() {
  myzsh_brew_install_or_upgrade antigen
  myzsh_activate_antigen
}

myzsh_uninstall_antigen() {
  myzsh_brew_uninstall antigen
  rm -rf "$ANTIGEN_DIRECTORY" &>/dev/null
}

myzsh_activate_antigen() {
  type antigen &>/dev/null && return

  if myzsh_is_homebrew_installed; then
    ANTIGEN_EXEC_DIRECTORY=$(brew --prefix antigen)/share/antigen
    if [ -f "$ANTIGEN_EXEC_DIRECTORY"/antigen.zsh ]; then
      # shellcheck disable=SC1091
      source "$ANTIGEN_EXEC_DIRECTORY"/antigen.zsh
      antigen use oh-my-zsh
      antigen bundle key-bindings
      if [ $MACHINE_TYPE = "Mac" ]; then
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
  myzsh_brew_install_or_upgrade rtx
  rtx_activation_file="$(brew --prefix rtx)/bin/rtx"
  eval "$($rtx_activation_file install)"
  myzsh_activate_rtx
}

myzsh_uninstall_rtx() {
  myzsh_brew_uninstall rtx
  rm -rf "$RTX_PREFIX"
}

myzsh_activate_rtx() {
  if myzsh_is_homebrew_installed; then
    rtx_activation_file="$(brew --prefix rtx)/bin/rtx"
    [ -f "$rtx_activation_file" ] && eval "$($rtx_activation_file activate zsh)"
  fi
  true
}

# Python
################################################################################

myzsh_install_python() {
  # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  myzsh_brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk pyenv
  print_line "Installing python $1"
  pyenv install "$1"
  pyenv global "$1"
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
  myzsh_brew_install_or_upgrade n
  print_line "Installing NodeJS $1"
  n "$1"
  myzsh_activate_node
  echo "NodeJS version:"
  node --version
}

myzsh_activate_node() {
  [ -d "$N_PREFIX"/bin ] && export PATH="$N_PREFIX/bin:$PATH"
  true
}

# Rust
################################################################################

myzsh_activate_rust() {
  # shellcheck disable=SC1091
  [ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"
  true
}

# Java
################################################################################

myzsh_install_java() {
  myzsh_install_homebrew
  brew tap homebrew/cask-versions
  myzsh_brew_install_or_upgrade --cask temurin17
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

myzsh_activate_docker() {
  # shellcheck disable=SC1091
  [ -f "$DOCKER_DIRECTORY/init-zsh.sh" ] && (source "$DOCKER_DIRECTORY/init-zsh.sh" || true)
}

# Neovim
################################################################################
myzsh_install_neovim() {
  myzsh_brew_install_or_upgrade homebrew/cask-fonts/font-meslo-lg-nerd-font
  myzsh_brew_install_or_upgrade neovim stylua
  npm install -g neovim tree-sitter-cli
  python3 -m pip install pynvim
}

myzsh_uninstall_neovim() {
  myzsh_brew_uninstall neovim stylua
  npm uninstall -g neovim tree-sitter-cli
  python3 -m pip uninstall -y pynvim
  rm -rf "$MYZSH_INSTALLED_DIR"/nvim/plugin/packer_compiled.lua
  rm -rf "$HOME"/.config/nvim
  rm -rf "$HOME"/.local/share/nvim
  rm -rf "$HOME"/.cache/nvim
}

# Mac key repeat for vscode
################################################################################

myzsh_fix_key_repeat_for_vscode() {
  if [ ! $MACHINE_TYPE = Linux ]; then
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  fi
}

# Keybindings
################################################################################

myzsh_keybindings() {
  # shellcheck disable=SC2154
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
  # shellcheck disable=SC2154
  bindkey "${terminfo[kcud1]}" history-substring-search-down
}

# Turn off beep
setopt nobeep

myzsh_activate_homebrew
myzsh_activate_antigen
myzsh_activate_cli_tools
myzsh_activate_rtx
myzsh_activate_python
myzsh_activate_node
myzsh_activate_rust
myzsh_activate_java
myzsh_activate_docker

myzsh_keybindings

[ -x "$HOME/.vocab" ] && "$HOME"/.vocab

# shellcheck disable=SC1091
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH=$HOME/.local/bin:$PATH

date
