# CONFIGURATIONS
################################################################################

export LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew
export HOMEBREW_DIRECTORY=/opt/homebrew
export N_PREFIX="$HOME/.n"

# HELPERS
################################################################################

activate_homebrew() {
  [ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  [ -d $HOMEBREW_DIRECTORY/bin ] && eval "$($HOMEBREW_DIRECTORY/bin/brew shellenv)"
  true
}

activate_pyenv() {
  command -v pyenv >/dev/null && eval "$(pyenv init -)"
  true
}

activate_n() {
  [ -d $N_PREFIX/bin ] && export PATH="$N_PREFIX/bin:$PATH"
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

# SET PARAMETERS
################################################################################

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

activate_homebrew
activate_pyenv
activate_n
activate_java
