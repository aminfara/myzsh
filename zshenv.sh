# CONFIGURATIONS
################################################################################

export LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew
export HOMEBREW_DIRECTORY_ARCH=/opt/homebrew
export HOMEBREW_DIRECTORY_X86=/usr/local/Homebrew
export N_PREFIX="$HOME/.n"
export DOCKER_DIRECTORY="$HOME/.docker"
export ASDF_DIRECTORY="$HOME/.asdf"

# HELPERS
################################################################################

[ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -d $HOMEBREW_DIRECTORY_ARCH/bin ] && eval "$($HOMEBREW_DIRECTORY_ARCH/bin/brew shellenv)"
[ -d $HOMEBREW_DIRECTORY_X86/bin ] && eval "$($HOMEBREW_DIRECTORY_X86/bin/brew shellenv)"
true

is_homebrew_installed() {
  if [ ! -v BREW_INSTALLED ]
  then
    type brew &>/dev/null
    export BREW_INSTALLED="$?"
  fi
  return $BREW_INSTALLED
}

activate_pyenv() {
  command -v pyenv >/dev/null && eval "$(pyenv init -)"
  true
}

activate_n() {
  [ -d $N_PREFIX/bin ] && export PATH="$N_PREFIX/bin:$PATH"
  true
}

activate_asdf() {
  if is_homebrew_installed
  then
    . "$(brew --prefix asdf)/libexec/asdf.sh"
  fi
  true
}

activate_java() {
  /usr/libexec/java_home &>/dev/null
  JAVA_EXISTS=$?
  if [ $JAVA_EXISTS -eq 0 ]; then
    JAVA_HOME=$(/usr/libexec/java_home)
    export JAVA_HOME
    export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
  fi
  true
}

activate_docker() {
  [ -f "$DOCKER_DIRECTORY/init-zsh.sh" ] && (source "$DOCKER_DIRECTORY/init-zsh.sh" || true)
}

# SET PARAMETERS
################################################################################

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

activate_pyenv
activate_n
activate_asdf
activate_java
activate_docker
