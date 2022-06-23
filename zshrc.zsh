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

MYZSH_INSTALLED_DIR=$HOME/.myzsh
ANTIGEN_DIRECTORY=$HOME/.antigen
BASE16_SHELL_DIRECTORY=$HOME/.config/base16-shell
LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew
ASDF_DIRECTORY=$HOME/.asdf
NPM_DIRECTORY=$HOME/.npm

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

SPACESHIP_GIT_SYMBOL="⎇  "
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_VI_MODE_INSERT=I
SPACESHIP_VI_MODE_NORMAL=N
SPACESHIP_VI_MODE_COLOR=black
SPACESHIP_TIME_SHOW=true
SPACESHIP_PROMPT_ORDER=(time user dir host git node venv exec_time line_sep battery vi_mode jobs exit_code char)

# HELPERs
################################################################################

print_line() {
  echo
  echo $@
  echo "--------------------------------------------------------------------------------"
}

is_homebrew_installed() {
  if [ ! -v BREW_INSTALLED ]
  then
    type brew &>/dev/null
    export BREW_INSTALLED=$?
  fi
  return $BREW_INSTALLED
}

brew_install_or_upgrade() {
  install_homebrew
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
  if is_homebrew_installed
  then
    print_line "Brew uninstalling $@"
    HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall --force "$@"
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

ssh() {
    command ssh "$@"
    RESULT=$?
    [ -f $HOME/.base16_theme ] && source $HOME/.base16_theme
    return RESULT
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
    if [ $MACHINE_TYPE = Linux ]
    then
      install_linux_build_essentials
    fi

    print_line "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    activate_homebrew
    unset BREW_INSTALLED
  fi
}

activate_homebrew() {
  [ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  true
}

# CLI goodies
################################################################################

install_cli_tools() {
  brew_install_or_upgrade git fd ripgrep fzf htop jq gnupg tree tmux lazygit shellcheck
  # Install fzf key bindings
  $(brew --prefix fzf)/install --key-bindings --completion --no-update-rc --no-bash --no-fish
  ln -s $MYZSH_INSTALLED_DIR/tmux.conf $HOME/.tmux.conf
  cp $MYZSH_INSTALLED_DIR/gitconfig-template $HOME/.gitconfig
  activate_cli_tools
}

uninstall_cli_tools() {
  brew_uninstall git fd ripgrep fzf htop jq gnupg tree tmux
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

# ANTIGEN
################################################################################

install_antigen() {
  brew_install_or_upgrade antigen
  activate_antigen
}

uninstall_antigen() {
  brew_uninstall antigen
  rm -rf $ANTIGEN_DIRECTORY &>/dev/null
}

activate_antigen() {
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
      antigen theme denysdovhan/spaceship-prompt
      antigen apply
    fi
  fi
}

# BASE16_SHELL
################################################################################
install_base16_shell() {
  git_install_or_update $BASE16_SHELL_DIRECTORY "chriskempson/base16-shell.git"
  activate_base16_shell
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
  brew_install_or_upgrade asdf
  activate_asdf
}

uninstall_asdf() {
  brew_uninstall asdf
  rm -rf $ASDF_DIRECTORY
}

activate_asdf() {
  if is_homebrew_installed
  then
    ASDF_SHELL=$(brew --prefix asdf)/libexec/asdf.sh
    [ -f "$ASDF_SHELL" ] && source $ASDF_SHELL
    [ -f "$ASDF_DIRECTORY/plugins/java/set-java-home.zsh" ] && source "$ASDF_DIRECTORY/plugins/java/set-java-home.zsh"
  fi
}

install_python() {
  # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk
  install_asdf
  print_line "Install asdf python plugin"
  asdf plugin add python
  path_backup=$PATH
  # TODO: remove on resolution of https://github.com/pyenv/pyenv/issues/2159
  if [ $MACHINE_TYPE = Linux ]
  then
    export PATH=$(echo $PATH | sed -e 's|/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:||')
  fi
  print_line "Installing python $1"
  asdf install python $1
  asdf global python $1
  asdf reshim python
  export PATH=$path_backup
  activate_asdf
  python3 -m pip install --upgrade pip
  echo "python version:"
  python --version
}

install_node() {
  install_asdf
  print_line "Install asdf nodejs plugin"
  asdf plugin add nodejs
  print_line "Installing nodejs $1"
  # mkdir -p ~/.gnupg
  # echo "standard-resolver" >  ~/.gnupg/dirmngr.conf
  asdf install nodejs $1
  asdf global nodejs $1
  asdf reshim nodejs
  activate_asdf
  echo "nodejs version:"
  node --version
}

install_java() {
  install_asdf
  print_line "Install asdf java plugin"
  asdf plugin add java
  print_line "Installing java $1"
  asdf install java $1
  asdf global java $1
  asdf reshim java
  activate_asdf
  echo "java version:"
  java -version
}

# NVIM
################################################################################
install_neovim() {
  brew_install_or_upgrade homebrew/cask-fonts/font-meslo-lg-nerd-font
  brew_install_or_upgrade neovim stylua
  npm install -g neovim tree-sitter-cli
  python3 -m pip install pynvim
}

uninstall_neovim() {
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

# Auto completion
################################################################################

update_auto_completions() {
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

activate_homebrew
update_auto_completions # should be before antigen
activate_antigen
activate_cli_tools
activate_asdf
activate_base16_shell

myzsh_keybindings


[ -x "$HOME/.vocab" ] && $HOME/.vocab

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH=$HOME/.local/bin:$PATH

export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

date
